import rclpy
from rclpy.node import Node
from std_msgs.msg import String
from geometry_msgs.msg import Point
from sensor_msgs.msg import CompressedImage
import cv2
from cv_bridge import CvBridge
import numpy as np

class SimulatorNode(Node):
    def __init__(self):
        super().__init__('simulator_node')

        # Publishers
        self.publisher_ = self.create_publisher(Point, "/RCR/joy/cmd_vel", 10)
        #        self.publisher_cam1 = self.create_publisher(CompressedImage, "/RCR/cam1/image_raw", 10)

        self.publisher_cam = [self.create_publisher(CompressedImage, "/RCR/cam1/image_raw", 10),
                              self.create_publisher(CompressedImage, "/RCR/cam2/image_raw", 10),
                              self.create_publisher(CompressedImage, "/RCR/cam3/image_raw", 10),
                              self.create_publisher(CompressedImage, "/RCR/cam4/image_raw", 10)]

        # Subscribers
        self.joy_subscriber = self.create_subscription(
            Point,
            '/RCR/joy/cmd_vel',
            self.joy_callback,
            10
        )

        self.publisher_flipper_left = self.create_publisher(String, "/RCR/FLF/flipper_control", 10)
        self.flipper_subscriber_left = self.create_subscription(
            String,
            '/RCR/FLF/flipper_control',
            self.flipper_callback,
            10
        )

        self.publisher_flipper_right = self.create_publisher(String, "/RCR/FRF/flipper_control", 10)
        self.flipper_subscriber_right = self.create_subscription(
            String,
            '/RCR/FRF/flipper_control',
            self.flipper_callback,
            10
        )

        self.publisher_flipper_back = self.create_publisher(String, "/RCR/BF/flipper_control", 10)
        self.flipper_subscriber_back = self.create_subscription(
            String,
            '/RCR/BF/flipper_control',
            self.flipper_callback,
            10
        )

        # Initialize OpenCV bridge
        self.bridge = CvBridge()

        # Initialize video capture
        self.cap = cv2.VideoCapture(0)  # Change the index if you have multiple cameras

        # Timer to publish images
        self.timer = self.create_timer(0.1, self.publish_image)  # Adjust the rate as needed

        self.get_logger().info('Simulator node started.')

    def joy_callback(self, msg):
        self.get_logger().info(f'Received JOY command: pos={msg.x},{msg.y}')

    def flipper_callback(self, msg):
        self.get_logger().info(f'Received flipper command: {msg.data}')

    def publish_image(self):
        ret, frame = self.cap.read()
        if not ret:
            self.get_logger().error('Failed to capture image')
            return
        
        # Encode frame in JPG
        _, buffer = cv2.imencode('.jpg', frame)
        
        # Create a ROS2 CompressedImage message
        msg = CompressedImage()
        msg.header.stamp = self.get_clock().now().to_msg()
        msg.format = "jpeg"
        msg.data = np.array(buffer).tobytes()

        # Publish the image
        for topic in self.publisher_cam:

            topic.publish(msg)
            self.get_logger().info('Published image to /RCR/cam1/image_raw')

def main(args=None):
    rclpy.init(args=args)
    node = SimulatorNode()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.cap.release()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()

