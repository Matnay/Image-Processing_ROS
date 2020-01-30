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
		image_1=image
		gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)				
		#_, gray = cv2.threshold(gray, 130, 255, cv2.THRESH_BINARY)
		#gaus = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_GAUSSIAN_C, cv2.THRESH_BINARY, 91, 12)
		#mean_c = cv2.adaptiveThreshold(gray, 255, cv2.ADAPTIVE_THRESH_MEAN_C, cv2.THRESH_BINARY, 15, 12)
		gray = np.float32(gray)
		dst = cv2.cornerHarris(gray,2,3,0.04)
		#cv2.imshow("window_1", dst )
		#cv2.waitKey(3)
		cv2.imshow('dst',dst)
		cv2.waitKey(3)
		
		

rospy.init_node('follower')
follower = Follower()
rospy.spin()
