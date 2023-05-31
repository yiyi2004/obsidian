- [[../Python Web|Python Web]]

- [ ] 对于 flask，恐怕你要系统的学习了，本来我还以为学起来挺简单的呢

## 基本使用

Flask 是一个流行的 Python Web 框架，用于快速开发 Web 应用程序。下面是 Flask 的基本使用方法的简要概述：

1. 安装 Flask：首先，确保已经安装了 Python。然后，使用 pip 命令安装 Flask。可以运行以下命令进行安装：

```
pip install flask
```

1. 导入 Flask 模块：在 Python 代码中，首先需要导入 Flask 模块：

```python
from flask import Flask
```

1. 创建 Flask 应用实例：创建一个 Flask 应用实例，通常使用以下代码：

```python
app = Flask(__name__)
```

1. 定义路由和视图函数：使用装饰器来定义路由和相应的视图函数，例如：

```python
@app.route('/')
def index():
    return 'Hello, Flask!'
```

上面的代码定义了根路由 '/' 并将其与名为 `index` 的视图函数绑定，当用户访问根路径时，将返回 'Hello, Flask!'。

1. 运行 Flask 应用：在代码的末尾添加以下代码，以运行 Flask 应用：

```python
if __name__ == '__main__':
    app.run()
```

这将在本地启动一个开发服务器，并监听默认端口（5000）。可以通过访问 `http://localhost:5000` 在浏览器中查看应用的输出。

这只是 Flask 的基本使用方法。Flask 还提供了许多其他功能，如模板渲染、表单处理、数据库集成等，可以根据具体需求进行深入学习和使用。

## Blueprint

- [ ] 解决导入不了模板的问题 #python

run.py

```python
## 导入 Flask 类

from flask import Flask  
from model_compare import simple
## 实例化，可视为固定格式

app = Flask(__name__)  
app.register_blueprint(simple)
## route() 方法用于设定路由；类似 Spring 路由配置

@app.route('/helloworld')  
def hello_world():  
    return 'Hello, World!'

if __name__ == '__main__':

## app.run(host, Port, Debug, options)

## 默认值：host="127.0.0.1", port=5000, debug=False

    app.run(host="0.0.0.0", port=5000)

```

model_compare.py

```python
## 导入 Flask 类

from flask import Blueprint

simple = Blueprint('simple', __name__, template_folder='templates')

## @app.route('/model_compare')

@simple.route('/model_compare', methods=['GET'])  
def hello_world():  
    return 'Hello, model_compare!'
```
