要在Python中安装MTCNN（Multi-task （Multi-task Cascaded Convolutional Networks），可以使用pip包管理器执行以下命令：

```
pip install mtcnn
```

这将从Python Package Index（PyPI）下载并安装MTCNN库及其依赖项。请确保您的计算机上已安装了适当的Python解释器和pip工具。

安装完成后，您可以在Python脚本中导入MTCNN并使用它来进行人脸检测。以下是一个简单的示例：

```python
from mtcnn import MTCNN

# 创建MTCNN对象
detector = MTCNN()

# 加载图像
image = cv2.imread('image.jpg')

# 进行人脸检测
faces = detector.detect_faces(image)

# 遍历检测到的人脸
for face in faces:
    # 提取人脸位置信息
    x, y, width, height = face['box']
    
    # 绘制人脸框
    cv2.rectangle(image, (x, y), (x+width, y+height), (255, 0, 0), 2)

# 显示结果图像
cv2.imshow('Faces', image)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

在上述示例中，我们首先导入MTCNN库并创建了一个MTCNN对象。然后，我们加载一张图像，并使用MTCNN对象的`detect_faces`方法进行人脸检测。检测到的人脸信息存储在`faces`列表中，我们可以遍历这个列表并根据人脸位置信息绘制人脸框。最后，我们显示带有人脸框的图像。

请注意，此示例假设您已安装了OpenCV库并将其命名为`cv2`模块。您可能需要在代码中相应地调整OpenCV导入语句以适应您的环境。