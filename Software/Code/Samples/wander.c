/** wander.c
 *
 *  This is a more advanced version of the tracker program. Makes the
 *  Create wander around, trying to follow the floor and not hit
 *  anything.  It will do this until it finds the color it is supposed
 *  to track, at which point it will move towards the object of that
 *  color.  If the robot loses the object, it will begin wandering
 *  around again. Requires OpenCV.
 *
 *  Author: Jesse DeGuire
 *
 *
 *  This file is part of COIL.
 *
 *  COIL is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  COIL is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with COIL.  If not, see <http://www.gnu.org/licenses/>.
 *
 *
 *  Versions:
 *      1.0     12 Jan 2008     Initial public release
 */

#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <createoi.h>

typedef struct
{
        unsigned char hue, saturation, value;
} Color;

void mouseCallback (int event, int x, int y, int flags, void* param);
int extractColor ();
void moveCreate (int Xpos);
void setFloorHistogram ();
CvScalar hsv2rgb (float hue);
int findFloor();
void printHelp();
void printSensors();

const int CAM_FOV               = 15;
const int FRAME_WIDTH   = 320;
const int FRAME_HEIGHT  = 240;
const int NO_COLOR              = -2147483647;
CvHistogram* hist;
Color targetColor = {0,0,0};
IplImage *frame, *huePlane, *satPlane, *valPlane, *imgHSV, *backproj, *smooth;
int hdims[3] = {12, 8, 4};
float **hranges;
IplImage** all_channels;
int yThreshold, key;    
byte createIsRunning = 0;

/** Main method */
int main(int argc, char* argv[])
{
        if (argc < 2)
        {
                printf ("Give location of serial port\n");
                return 1;
        }                      
        int avgX, i;
        yThreshold = FRAME_HEIGHT / 4;
       
        startOI (argv[1]);
        enterSafeMode();
       
        CvCapture* camera;

        if (0 == (camera = cvCaptureFromCAM (CV_CAP_ANY)))
        {
          fprintf (stderr, "Could not connect to camera\n");
          return -1;
        }
        printHelp();

        cvSetCaptureProperty (camera, CV_CAP_PROP_FRAME_WIDTH, FRAME_WIDTH);
        cvSetCaptureProperty (camera, CV_CAP_PROP_FRAME_HEIGHT, FRAME_HEIGHT);
       
        frame = cvQueryFrame (camera);
        imgHSV = cvCreateImage (cvGetSize (frame), 8, 3);
        smooth = cvCreateImage (cvGetSize (frame), 8, 3);
        huePlane = cvCreateImage (cvGetSize (frame), 8, 1);
        satPlane = cvCreateImage (cvGetSize (frame), 8, 1);
        valPlane = cvCreateImage (cvGetSize (frame), 8, 1);
        backproj = cvCreateImage (cvGetSize (frame), 8, 1);

        cvNamedWindow ("Camera Image", CV_WINDOW_AUTOSIZE);
        cvNamedWindow ("Backprojection", CV_WINDOW_AUTOSIZE);
       
        all_channels = (IplImage**)malloc(3* sizeof(IplImage *));
        hranges = (float**)malloc(3* sizeof(float *));
        hranges[0] = (float*)malloc(3 * 2 * sizeof(float));
        for(i = 1; i < 3; i++){
          hranges[i] = hranges[0] + i * 2;
        }
        hranges[0][0] = 0;
        hranges[0][1] = 180;
        hranges[1][0] = 0;
        hranges[1][1] = 255;
        hranges[2][0] = 0;
        hranges[2][1] = 255;
       
        hist = cvCreateHist( 3, hdims, CV_HIST_ARRAY, hranges, 1 );
        all_channels[0] = huePlane;
        all_channels[1] = satPlane;
        all_channels[2] = valPlane;
        setFloorHistogram ();
       
        cvSetMouseCallback ("Camera Image", mouseCallback, 0);
       
        while (1)
        {
                frame = cvQueryFrame (camera);
                cvCvtColor (frame, imgHSV, CV_BGR2HSV);
                cvSmooth (imgHSV, smooth, CV_GAUSSIAN, 11, 11, 0, 0);
                cvSplit (imgHSV, huePlane, satPlane, valPlane, 0 );
                all_channels[0] = huePlane;
                all_channels[1] = satPlane;
                all_channels[2] = valPlane;
               
                /* This assumes that we have a clear shot at getting to the object when we see its color.
                 * Not always true, so we'll have to monitor bumper state when driving.  If we don't see
                 * the object we want, then we'll just find some more floor and wander a bit. */
                avgX = extractColor ();
                if (NO_COLOR == avgX)
                        avgX = findFloor();
                moveCreate (avgX);
               
                key = cvWaitKey (10) & 255;
               
                if (32 == key)                                  //toggle Create's movement with spacebar
                {
                        if (createIsRunning)                                            
                        {
                                printSensors();
                                directDrive (0, 0);
                                createIsRunning = 0;
                        }
                        else                                                                            
                                createIsRunning = 1;
                }
                if ('.' == key && yThreshold < FRAME_HEIGHT)    //raise threshold
                {
                  yThreshold++;
                  cvRectangle (frame, cvPoint (FRAME_WIDTH / 3, FRAME_HEIGHT - yThreshold),
                               cvPoint (2 * FRAME_WIDTH / 3, FRAME_HEIGHT), CV_RGB(255, 255, 0),
                               1, 4, 0);
                  setFloorHistogram ();
                }
                if (',' == key && yThreshold > 1)                               //lower threshold
                {
                  yThreshold--;
                  cvRectangle (frame, cvPoint (FRAME_WIDTH / 3, FRAME_HEIGHT - yThreshold),
                               cvPoint (2 * FRAME_WIDTH / 3, FRAME_HEIGHT), CV_RGB(255, 255, 0),
                               1, 4, 0);
                  setFloorHistogram ();
                }
                if ('r' == key)                                                 //reset color to {0,0,0}
                {
                        targetColor.hue = 0;
                        targetColor.saturation = 0;
                        targetColor.value = 0;
                }
                if (27 == key)                                                  //quit on Escape key press
                        break;

                cvShowImage ("Camera Image", frame);
        }

        stopOI();
        cvDestroyAllWindows();
        cvReleaseImage (&smooth);
        cvReleaseImage (&imgHSV);
        cvReleaseImage (&huePlane);
        cvReleaseImage (&satPlane);
        cvReleaseImage (&valPlane);
        cvReleaseImage (&backproj);
        cvReleaseHist (&hist);
        //cvReleaseImage (&frame);
        cvReleaseCapture (&camera);
        return 0;
}

/**     \brief  Callback function for GUI
 *
 *      Mouse callback function used to allow the GUI to respond to mouse clicks.  In this case, a left
 *      button click will change the target color. This function is not meant to be called directly.
 *
 *      \param  event   mouse event
 *      \param  x               x pos of mouse
 *      \param  y               y pos of mouse
 *      \param  flags   modifier keys held with mouse button
 *      \param  param   not used
 */
void mouseCallback (int event, int x, int y, int flags, void* param)
{
        if (CV_EVENT_LBUTTONDOWN == event)
        {
                unsigned char* temp = &((unsigned char*)(smooth->imageData +
                                smooth->widthStep*y))[x*3];
                targetColor.hue                 = temp[0];
                targetColor.saturation  = temp[1];
                targetColor.value               = temp[2];
        }
        return;
}

/** \brief      Gets new color and returns average X position
 *
 *  This function returns the average X position of the color in the image, which is needed
 *  for the Create to move.  The center of the image has an X equal to 0.
 *
 *  \return     the average X position of the given color or NO_COLOR if it is not in the image
 */
int extractColor ()
{
        if (0 == targetColor.hue && 0 == targetColor.saturation && 0 == targetColor.value)
                return NO_COLOR;
               
        byte* img_ptr;
        int numfound = 0, total_x = 0, total_y = 0;
        int x, y, llimit, ulimit, tol = 5;

        //stop "rollover" of saturation bounds
        if (targetColor.saturation < tol)
          ulimit = 0;
        else
          ulimit = targetColor.saturation - tol;
        if (targetColor.saturation > 255 - tol)
          llimit = 255;
        else
          llimit = targetColor.saturation + tol;
       
        for (y = 0; y < smooth->height; y++)
        {
                for (x = 0; x < smooth->width; x++)
                {
                        img_ptr = &((byte*)(smooth->imageData + smooth->widthStep*y))[x*3];

                        if (img_ptr[0] == targetColor.hue && img_ptr[1] >= ulimit && img_ptr[1] <= llimit
                                && img_ptr[2] > targetColor.value - tol && img_ptr[2] < targetColor.value + tol)
                        {
                                numfound++;
                                total_x += x;
                                total_y += y;
                        }
                }
        }
       
        if (0 == numfound)
                return NO_COLOR;
       
        cvLine (frame, cvPoint (total_x / numfound, total_y / numfound),
                        cvPoint (FRAME_WIDTH / 2, FRAME_HEIGHT-1), CV_RGB (0, 255, 0), 2, 4, 0);
        return  total_x / numfound;
}

/** \brief      Directs Create's motion based on image info
 *
 *  Tells the Create to move based on the value of Xpos.  Create will try to move such that Xpos
 *  is close to 0.  If Xpos is NO_COLOR, then the Create will spin in a circle in an attempt to
 *  find the color.
 *
 *  \param      Xpos    X position of the object the Create should be following
 */
void moveCreate (int Xpos)
{
        int angle, tol = 20, bumper = 0;
       
        if (!createIsRunning)
                return;
       
        bumper = getBumpsAndWheelDrops();
       
        if (0 != bumper)                                                        //sensor was tripped
        {
                if (1 == bumper)
                {
                        drive (120, 1);
                        waitAngle (45, 1);
                }
                else if (2 == bumper)
                {
                        drive (120, -1);
                        waitAngle (-45, 1);
                }
                else if (3 == bumper)
                {
                        drive (250, -1);
                        waitAngle (-90, 1);
                }
        }
        else if (NO_COLOR == Xpos)                              //if object is not in frame, spin to find it
                drive (120, -1);
        else if (Xpos < tol && Xpos > -tol)             //move toward object if it is straight ahead
                drive (250, 0);
        else                                                                    //else turn toward object
        {
                angle = -CAM_FOV / ((FRAME_WIDTH / 2) / Xpos);
               
                if (angle < 0)
                        drive (200 - 5*angle, -200 + 10*angle);
                else
                        drive (200 - 5*angle, 200 - 10*angle);
        }
        return;
}

/** \brief  Set color histogram for floor
 *
 *      Uses the lower portion of an image to set the histogram for the floor.  The function just uses the lower
 *  portion of the image to find it since we can assume that the floor will always be down there.
 */
void setFloorHistogram ()
{
        CvRect rect = cvRect (FRAME_WIDTH / 3, FRAME_HEIGHT - yThreshold,
                              FRAME_WIDTH / 3, yThreshold);
       
        cvSetImageROI (huePlane, rect);
        cvSetImageROI (satPlane, rect);
        cvSetImageROI (valPlane, rect);
        cvCalcHist (all_channels, hist, 0, 0);
        cvNormalizeHist (hist, 1024);
        cvResetImageROI (huePlane);
        cvResetImageROI (satPlane);
        cvResetImageROI (valPlane);
}

/** \brief Finds area with most floor ahead
 *
 *  Gets the backprojection of the current frame and uses that to find the X coordinate of the area where the
 *  floor extends furthest into the image frame.
 *
 *  \return     X position of the region with the most floor space
 */
int findFloor ()
{
        cvCalcBackProject (all_channels, backproj, hist);
        cvSmooth (backproj, backproj, CV_GAUSSIAN, 21, 21,0, 0 );
        cvThreshold (backproj, backproj, 25, 255, CV_THRESH_BINARY );
        cvShowImage ("Backprojection", backproj);
        byte* img_ptr;
        int i, x, y, x_max = 0, y_max = FRAME_HEIGHT;

        for (i = 0; i < FRAME_WIDTH; i++)
        {
          x = (FRAME_WIDTH / 2 + i) % FRAME_WIDTH;      //start in middle of image

          for (y = FRAME_HEIGHT - 1; y > 0; y--)
          {
            img_ptr = &((byte*)(backproj->imageData + backproj->widthStep*y))[x];

            if (*(img_ptr - 1) != 255)
            {
                        if (y < y_max)
                        {
                                x_max = x;
                                y_max = y;
                        }
                        break;
            }
          }
        }
        cvLine (frame, cvPoint (x_max, y_max), cvPoint (FRAME_WIDTH / 2, FRAME_HEIGHT-1),
                        CV_RGB (255, 0, 0), 2, 4, 0);
        return x_max - (FRAME_WIDTH / 2);
}

/** \brief      Converts hue to RGB value
 *
 *      Converts a single hue value to an RGB value, which is stored in a CvScalar type.  Taken directly
 *      from the OpenCV Camshift demo.
 *
 *      \param  hue             Hue value to convert
 *
 *      \return         a CvScalar of the new RGB value.
 */
CvScalar hsv2rgb( float hue )
{
        int rgb[3], p, sector;
        static const int sector_data[][3]=
        {{0,2,1}, {1,2,0}, {1,0,2}, {2,0,1}, {2,1,0}, {0,1,2}};
        hue *= 0.033333333333333333333333333333333f;
        sector = cvFloor(hue);
        p = cvRound(255*(hue - sector));
        p ^= sector & 1 ? 255 : 0;

        rgb[sector_data[sector][0]] = 255;
        rgb[sector_data[sector][1]] = 0;
        rgb[sector_data[sector][2]] = p;

        return cvScalar(rgb[2], rgb[1], rgb[0],0);
}

/** Prints a help message in the console telling the user how to use this program. */
void printHelp ()
{
        printf ("\n\n Make your Create wander around on the floor and follow objects by color\n\n");
        printf ("Click on the image to select a color you want the robot to follow and then press spacebar to make it go.  ");
        printf ("The Create will wander around until it finds the color representing the object you clicked on.  ");
        printf ("At that point it will move toward the object.\n");
        printf ("A line will point towards the direction the Create will move.");
        printf ("A red line means the Create is wandering and a green line means the Create found the object.");
        printf ("\n\n Review of hotkeys:\n");
        printf ("ESC \t Quit program\n");
        printf ("Space\t Make Create stop or go\n");
        printf ("> \t Increase area used for finding floor\n");
        printf ("< \t Decrease area used for finding floor\n");
        printf ("R \t Reset program to no target color (Create will just wander)\n");
        printf ("Click left mouse button to select a target color for Create to find");
        printf ("\n\n Note that this software is still in testing phases.\n\n");
}

void printSensors()
{
        int* sensors = getAllSensors();
        int i;
       
        for (i = 0; i < 36; i++)
        {
                printf ("Sensor %d:\t%d\n", i, sensors[i]);
        }
        free (sensors);
}
