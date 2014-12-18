/** tracker.h
 *
 *  Header file for tracker program.  Contains definition for Color type, some used constants,
 *  and function signatures.
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

/**     Defines a 3 component color system.  Meant for use with HSV, but could really be used for any
 *      color.
 */
typedef struct
{
        unsigned char hue, saturation, value;
} Color;

/** Camera's field of view from centerline in degrees.  In other words, the outermost edge of the
 *      image will see objects that are CAM_FOV degrees off center.
 */
const int CAM_FOV               = 15;
const int FRAME_WIDTH   = 320;                                  ///< Width of frame in pixels (depends on camera)
const int FRAME_HEIGHT  = 240;                                  ///< Height of frame in pixels (depends on camera)
const int NO_COLOR              = -2147483647;                  ///< Used if target color is not in video stream

void mouseCallback (int event, int x, int y, int flags, void* param);
int extractColor (IplImage* img, Color* clr);
int extractColorDebug (IplImage* img, Color* clr);
void moveCreate (int Xpos);
int setFloorHistogram ();
