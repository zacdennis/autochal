/** tracker.c
 *
 *  This is a simple color-based tracking system that will allow the Create to follow a selected
 *  color from the webcam feed.  In its current form, this tracker is extremely limited in that it
 *  can only follow a set of colors, so your target should be a unique color in the area the Create
 *  is in (like a bright pink or yellow).  Requires OpenCV.
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
#include "tracker.h"
#include <createoi.h>

Color targetColor = {0,0,0};                            //color to track
IplImage* frame;                                        //current capture frame
IplImage* track;
int cVel = 0, cRad = 0;                                 //Create's velocity and turning radius
int avgX;
byte createIsRunning = 0;
byte debugMode = 0;                                     //if 1, show color tracking

int main(int argc, char* argv[])
{
        if (argc < 2)
        {
                printf ("Give location of serial port\n");
                return 1;
        }
        if ("-d" == argv[2])
                debugMode = 1;
       
        startOI (argv[1]);
        enterSafeMode();
       
        CvCapture* camera = cvCaptureFromCAM (CV_CAP_ANY);              //capture stream
        cvSetCaptureProperty (camera, CV_CAP_PROP_FRAME_WIDTH, FRAME_WIDTH);
        cvSetCaptureProperty (camera, CV_CAP_PROP_FRAME_HEIGHT, FRAME_HEIGHT);
       
        //create windows
        char* capWin = "Camera Image";
        char* trackWin = "Color Tracker";
        cvNamedWindow (capWin, CV_WINDOW_AUTOSIZE);
       
        if (debugMode)
                cvNamedWindow (trackWin, CV_WINDOW_AUTOSIZE);

        //set up mouse callback function
        cvSetMouseCallback (capWin, mouseCallback, 0);
       
        while (1)
        {
                frame = cvQueryFrame (camera);
                cvShowImage (capWin, frame);
               
                if (debugMode)                                                                  //show color tracker
                {
                        avgX = extractColorDebug (frame, &targetColor);
                        cvShowImage (trackWin, track);
                        cvReleaseImage (&track);
                }
                else
                        avgX = extractColor (frame, &targetColor);
               
                moveCreate (avgX);

                if ((cvWaitKey (5) & 255) == 32)                                //toggle Create's movement with spacebar
                {
                        if (createIsRunning)                                            //stop Create
                        {
                                directDrive (0, 0);
                                createIsRunning = 0;
                        }
                        else                                                                            //let Create run
                                createIsRunning = 1;
                }
                if ((cvWaitKey (5) & 255) == 27)                                //quit on Escape key press
                        break;
        }

        stopOI();
        cvDestroyAllWindows();
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
                        IplImage* frameHSV = cvCloneImage (frame);
                        cvCvtColor (frameHSV, frameHSV, CV_BGR2HSV);
       
                        unsigned char* temp = &((unsigned char*)(frameHSV->imageData +
                                        frameHSV->widthStep*y))[x*3];
                        targetColor.hue                 = temp[0];
                        targetColor.saturation  = temp[1];
                        targetColor.value               = temp[2];
       
                        cvReleaseImage (&frameHSV);
        }
        return;
}

/** \brief      Gets new color and returns average X position
 *
 *  This function returns the average X position of the color in the image, which is needed
 *      for     the Create to move.  The center of the image has an X equal to 0.
 *
 *      \param  img             the image to search through
 *      \param  clr             the color to track
 *
 *      \return         the average X position of the given color or NO_COLOR if it is not in the image
 */
int extractColor (IplImage* img, Color* clr)
{
        IplImage* imgHSV = cvCloneImage (img);  
        cvCvtColor (imgHSV, imgHSV, CV_BGR2HSV);

        unsigned char* img_ptr;
        unsigned char* out_ptr;
        int numfound = 0, total_x = 0;
        int x, y, llimit, ulimit, tol = 5;

        //start traversing columns
        for (y = 0; y < img->height; y++)
        {
                //move along column through the rows
                for (x = 0; x < img->width; x++)
                {
                        //pointers to image points
                        img_ptr = &((unsigned char*)(imgHSV->imageData + imgHSV->widthStep*y))[x*3];

                        //stop "rollover" of saturation bounds
                        if (img_ptr[1] < tol)
                                ulimit = 0;
                        else ulimit = img_ptr[1] - tol;
                        if (img_ptr[1] > 255 - tol)
                                llimit = 255;
                        else llimit = img_ptr[1] + tol;

                        //if current point closely matches target color, add it in
                        if (img_ptr[0] == clr->hue && img_ptr[1] >= ulimit && img_ptr[1] <= llimit)
                        {
                                numfound++;
                                total_x += x - (FRAME_WIDTH / 2);
                        }
                }
        }
        cvReleaseImage (&imgHSV);
       
        if (0 == numfound)
                return NO_COLOR;
       
        return  total_x / numfound;
}

/** \brief      Gets new color and returns average X position (debug)
 *
 *      This function returns the average X position of the color in the image, which is needed for the
 *      Create to move.  The center of the image has an X equal to 0.  Also searches through the given
 *      image for the given target color and paints that color into the tracking image.  This allows you
 *      to see where in the image the target color is located.
 *
 *      \param  img             the image to search through
 *      \param  clr             the color to track
 *
 *      \return         the average X position of the given color or NO_COLOR if it is not in the image
 */
int extractColorDebug (IplImage* img, Color* clr)
{
        IplImage* imgHSV = cvCloneImage (img);
        IplImage* output  = cvCreateImage (cvSize (img->width, img->height), IPL_DEPTH_8U, 3);
       
        cvCvtColor (imgHSV, imgHSV, CV_BGR2HSV);

        unsigned char* img_ptr;
        unsigned char* out_ptr;
        int numfound = 0, total_x = 0;
        int x, y, llimit, ulimit, tol = 5;

        //start traversing columns
        for (y = 0; y < img->height; y++)
        {
                //move along column through the rows
                for (x = 0; x < img->width; x++)
                {
                        //pointers to image points
                        img_ptr = &((unsigned char*)(imgHSV->imageData + imgHSV->widthStep*y))[x*3];
                        out_ptr = &((unsigned char*)(output->imageData + output->widthStep*y))[x*3];

                        //stop "rollover" of saturation bounds
                        if (img_ptr[1] < tol)
                                ulimit = 0;
                        else ulimit = img_ptr[1] - tol;
                        if (img_ptr[1] > 255 - tol)
                                llimit = 255;
                        else llimit = img_ptr[1] + tol;

                        //if current point closely matches target color, make output point that color
                        if (img_ptr[0] == clr->hue && img_ptr[1] >= ulimit && img_ptr[1] <= llimit)
                        {
                                out_ptr[0] = img_ptr[0];
                                out_ptr[1] = img_ptr[1];
                                out_ptr[2] = img_ptr[2];
                               
                                numfound++;
                                total_x += x - (FRAME_WIDTH / 2);
                        }
                }
        }
                       
        cvCvtColor (output, output, CV_HSV2BGR);
        track = output;
        cvReleaseImage (&imgHSV);
       
        if (0 == numfound)
                return NO_COLOR;
       
        return  total_x / numfound;
}

/** \brief      Directs Create's motion based on image info
 *
 *      Tells the Create to move based on the value of Xpos.  Create will try to move such that Xpos
 *      is close to 0.  If Xpos is NO_COLOR, then the Create will spin in a circle in an attempt to
 *      find the color.
 *
 *      \param  Xpos    X position of the object the Create should be following
 */
void moveCreate (int Xpos)
{
        int angle;
        int tol = 20;
       
        if (!createIsRunning)
                return;
       
        if (NO_COLOR == Xpos)                                   //if object is not in frame, spin to find it
        {
                cVel = 120;
                cRad = -1;
        }
        else if (Xpos < tol && Xpos > -tol)             //move toward object if it is straight ahead
        {
                cVel = 250;
                cRad = 0;
        }      
        else                                                                    //else turn toward object
        {
                angle = -CAM_FOV / ((FRAME_WIDTH / 2) / Xpos);
               
                if (angle < 0)
                {
                        cVel = 200 - 5*angle;
                        cRad = -200 + 10*angle;
                }
                else
                {
                        cVel = 200 - 5*angle;
                        cRad = 200 - 10*angle;
                }
        }
        drive (cVel, cRad);
        return;
}
