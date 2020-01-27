#!/usr/bin/env python
from std_msgs.msg import Int32
import rospy, cv2, cv_bridge, numpy
from sensor_msgs.msg import Image
import cv2
import numpy as np
from matplotlib import pyplot as plt

class Follower:
	def __init__(self):
		self.bridge = cv_bridge.CvBridge()
		self.image_sub = rospy.Subscriber('/usb_cam/image_raw',Image, self.image_callback)
		#self.image_pub = rospy.Publisher('gray_image',Int32,queue_size=1)
	def image_callback(self, msg):
		image = self.bridge.imgmsg_to_cv2(msg)
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)				
		_, gray = cv2.threshold(gray, 130, 255, cv2.THRESH_BINARY)
		gaus = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 91, 12)
		mean_c = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 15, 12)
		cv2.imshow("window", gray )
		cv2.waitKey(3)
		#apply canny edge detection to the image
		edges = cv2.Canny(gray,50,150,apertureSize = 3)
		cv2.imshow("canny'd image", edges)
		cv2.waitKey(3)
		lines = cv2.HoughLines(edges,1,np.pi/180,20)
		#create an array for each direction, where array[0] indicates one of the lines and array[1] indicates the other, which if both > 0 will tell us the orientation
		left = [0, 0]
		right = [0, 0]
		up = [0, 0]
		down = [0, 0]
		#iterate through the lines that the houghlines function returned
		for object in lines:
		    theta = object[0][1]
		    rho = object[0][0]
		    #cases for right/left arrows
		    if ((np.round(theta, 2)) >= 1.0 and (np.round(theta, 2)) <= 1.1) or ((np.round(theta,2)) >= 2.0 and (np.round(theta,2)) <= 2.1):
			if (rho >= 20 and rho <=  30):
			    left[0] += 1
			elif (rho >= 60 and rho <= 65):
			    left[1] +=1
			elif (rho >= -73 and rho <= -57):
			    right[0] +=1
			elif (rho >=148 and rho <= 176):
			    right[1] +=1
		    #cases for up/down arrows
		    elif ((np.round(theta, 2)) >= 0.4 and (np.round(theta,2)) <= 0.6) or ((np.round(theta, 2)) >= 2.6 and (np.round(theta,2))<= 2.7):
			if (rho >= -63 and rho <= -15):
			    up[0] += 1
			elif (rho >= 67 and rho <= 74):
			    down[1] += 1
			    up[1] += 1
			elif (rho >= 160 and rho <= 171):
			    down[0] += 1

		if left[0] >= 1 and left[1] >= 1:
		    print("left")
		elif right[0] >= 1 and right[1] >= 1:
		    print("right")
		elif up[0] >= 1 and up[1] >= 1:
		    print("up")
		elif down[0] >= 1 and down[1] >= 1:
		    print("down")

		print(up, down, left, right)

rospy.init_node('follower')
follower = Follower()
rospy.spin()
