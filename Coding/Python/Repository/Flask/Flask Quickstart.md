
- Time：2023-05-31 16:01
- Label： #python #flask #web

## Abstract

A simple quickstart for flask

you must learn from how to study the first hand materials

## Content

### A Minimal Application

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"
```

```shell
$ flask --app hello run
 * Serving Flask app 'hello'
 * Running on http://127.0.0.1:5000 (Press CTRL+C to quit)
```

- app.py or wsgi.py you don't need to use `--app`

The `flask run` command can do more than just start the development server. By enabling debug mode, the server will automatically **reload if code changes**, and will **show an interactive debugger in the browser** if an error occurs during a request.

```shell
flask run --host=0.0.0.0
# debug
flask --app hello run --debug 
```

### HTML Escaping

HTML Escaping（HTML 转义）是一种处理 HTML 文本中特殊字符的机制，以确保这些字符被正确地显示而不会被解释为 HTML 标签或特殊符号。在 HTML 中，某些字符具有特殊含义，如 `<`, `>`, `&`, `"`, `'` 等，如果不进行转义，这些字符可能会干扰 HTML 文档的结构或导致安全漏洞。

HTML 转义通过将特殊字符替换为对应的转义序列来实现。例如，将 `<` 替换为 `&lt;`，将 `>` 替换为 `&gt;`，将 `&` 替换为 `&amp;`，将 `"` 替换为 `&quot;`，将 `'` 替换为 `&#39;` 等。这样，当在 HTML 文档中显示这些字符时，它们会被正确地解释为普通的文本内容，而不会被解释为 HTML 标签或其他特殊含义。

HTML 转义可以防止 XSS（跨站脚本攻击）等安全漏洞，并确保在 HTML 文档中正确地显示和呈现特殊字符。在开发 Web 应用程序时，对于从用户输入或其他外部来源获取的数据，应该进行 HTML 转义处理，以增加应用程序的安全性。常用的编程语言和框架提供了相关的函数或工具来执行 HTML 转义操作。

```python
from markupsafe import escape

@app.route("/<name>")
def hello(name):
    return f"Hello, {escape(name)}!"
```

If a user managed to submit the name `<script>alert("bad")</script>`, escaping causes it to be rendered as text, rather than running the script in the user’s browser.

### Routing

|          |                                            |
| -------- | ------------------------------------------ |
| `string` | (default) accepts any text without a slash |
| `int`    | accepts positive integers                  |
| `float`  | accepts positive floating point values     |
| `path`   | like `string` but also accepts slashes     |
| `uuid`   | accepts UUID strings                       |

The canonical URL for the `projects` endpoint has a trailing slash. It’s similar to a folder in a file system. If you access the URL without a trailing slash (`/projects`), Flask **redirects** you to the canonical URL with the trailing slash (`/projects/`).

url building

```python
from flask import url_for

@app.route('/')
def index():
    return 'index'

@app.route('/login')
def login():
    return 'login'

@app.route('/user/<username>')
def profile(username):
    return f'{username}\'s profile'

with app.test_request_context():
    print(url_for('index'))
    print(url_for('login'))
    print(url_for('login', next='/'))
    print(url_for('profile', username='John Doe'))
```

```shell
/
/login
/login?next=/
/user/John%20Doe
```

HTTP method

```python
from flask import request

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        return do_the_login()
    else:
        return show_the_login_form()
```

```python
@app.get('/login')
def login_get():
    return show_the_login_form()

@app.post('/login')
def login_post():
    return do_the_login()
```

### Static Files

```python
url_for('static', filename='style.css')
```

The file has to be stored on the filesystem as `static/style.css`.

### Rendering Templates

Generating HTML from within Python is not fun, and actually pretty cumbersome because you have to do the HTML escaping on your own to keep the application secure. Because of that Flask configures the [Jinja2](https://palletsprojects.com/p/jinja/) template engine for you automatically.

```python
@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)
```

Flask will look for templates in the `templates` folder. So if your application is a module, this folder is next to that module, if it’s a package it’s actually inside your package:  
**Case 1**: a module:

```
/application.py
/templates
    /hello.html
```

**Case 2**: a package:

```
/application
    /__init__.py
    /templates
        /hello.html
```

For templates you can use the full power of Jinja2 templates. Head over to the official [Jinja2 Template Documentation](https://jinja.palletsprojects.com/templates/) for more information.

```html
<!doctype html>
<title>Hello from Flask</title>
{% if name %}
  <h1>Hello {{ name }}!</h1>
{% else %}
  <h1>Hello, World!</h1>
{% endif %}
```

Changed in version 0.5: Autoescaping is no longer enabled for all templates. The following extensions for templates trigger autoescaping: `.html`, `.htm`, `.xml`, `.xhtml`. Templates loaded from a string will have autoescaping disabled.

### Accessing Request Data

#### Context Locals

> skip it

#### The Request Object

```python
@app.route('/login', methods=['POST', 'GET'])
def login():
    error = None
    if request.method == 'POST':
        if valid_login(request.form['username'],
                       request.form['password']):
            return log_the_user_in(request.form['username'])
        else:
            error = 'Invalid username/password'
    # the code below is executed if the request method
    # was GET or the credentials were invalid
    return render_template('login.html', error=error)
```

We recommend accessing URL parameters with get or by catching the [`KeyError`](https://docs.python.org/3/library/exceptions.html#KeyError "(in Python v3.11)") because users might change the URL and presenting them a 400 bad request page in that case is not user friendly.

For a full list of methods and attributes of the request object, head over to the [`Request`](https://flask.palletsprojects.com/en/2.3.x/api/#flask.Request "flask.Request") documentation.

#### File Uploads

```python
from werkzeug.utils import secure_filename

@app.route('/upload', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['the_file']
        file.save(f"/var/www/uploads/{secure_filename(file.filename)}")
    ...
```

For some better examples, see [Uploading Files](https://flask.palletsprojects.com/en/2.3.x/patterns/fileuploads/).

#### Cookies

```python
@app.route('/')
def index():
    username = request.cookies.get('username')
    # use cookies.get(key) instead of cookies[key] to not get a
    # KeyError if the cookie is missing.

```

```python
from flask import make_response

@app.route('/')
def index():
    resp = make_response(render_template(...))
    resp.set_cookie('username', 'the username')
    return resp
```

为什么你不直接用 golang 去做呢

### Redirects and Errors

```python
from flask import abort, redirect, url_for

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/login')
def login():
    abort(401)
    this_is_never_executed()
```

handle error

```python
from flask import render_template

@app.errorhandler(404)
def page_not_found(error):
    return render_template('page_not_found.html'), 404
```

### About Responses

```python
from flask import render_template

@app.errorhandler(404)
def not_found(error):
    return render_template('error.html'), 404
```

```python
from flask import make_response

@app.errorhandler(404)
def not_found(error):
    resp = make_response(render_template('error.html'), 404)
    resp.headers['X-Something'] = 'A value'
    return resp
```

#### APIs with JSON

```python
@app.route("/me")
def me_api():
    user = get_current_user()
    return {
        "username": user.username,
        "theme": user.theme,
        "image": url_for("user_image", filename=user.image),
    }

@app.route("/users")
def users_api():
    users = get_all_users()
    return [user.to_json() for user in users]
```

```python
	return [user.to_json() for user in users]
```

### Sessions

```python
from flask import session

# Set the secret key to some random bytes. Keep this really secret!
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

@app.route('/')
def index():
    if 'username' in session:
        return f'Logged in as {session["username"]}'
    return 'You are not logged in'

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
    '''

@app.route('/logout')
def logout():
    # remove the username from the session if it's there
    session.pop('username', None)
    return redirect(url_for('index'))
```

- generate key

```python
python -c 'import secrets; print(secrets.token_hex())'
'192b9bdd22ab9ed4d12e236c78afcb9a393ec15f71bbf5dc987d54727823bcbf'
```

### Message Flashing

Good applications and user interfaces are all about feedback. If the user does not get enough feedback they will probably end up hating the application. **Flask provides a really simple way to give feedback to a user with the flashing system.** The flashing system basically makes it possible to record a message at the end of a request and access it on the next (and only the next) request. This is usually combined with a layout template to expose the message.

To flash a message use the [`flash()`](https://flask.palletsprojects.com/en/2.3.x/api/#flask.flash "flask.flash") method, to get hold of the messages you can use [`get_flashed_messages()`](https://flask.palletsprojects.com/en/2.3.x/api/#flask.get_flashed_messages "flask.get_flashed_messages") which is also available in the templates. See [Message Flashing](https://flask.palletsprojects.com/en/2.3.x/patterns/flashing/) for a full example.

### Logging

```python
app.logger.debug('A value for debugging')
app.logger.warning('A warning occurred (%d apples)', 42)
app.logger.error('An error occurred')
```

The attached [`logger`](https://flask.palletsprojects.com/en/2.3.x/api/#flask.Flask.logger "flask.Flask.logger") is a standard logging [`Logger`](https://docs.python.org/3/library/logging.html#logging.Logger "(in Python v3.11)"), so head over to the official [`logging`](https://docs.python.org/3/library/logging.html#module-logging "(in Python v3.11)") docs for more information.

See [Handling Application Errors](https://flask.palletsprojects.com/en/2.3.x/errorhandling/).

### Hooking in WSGI

To add WSGI middleware to your Flask application, wrap the application’s `wsgi_app` attribute. For example, to apply Werkzeug’s [`ProxyFix`](https://werkzeug.palletsprojects.com/en/2.3.x/middleware/proxy_fix/#werkzeug.middleware.proxy_fix.ProxyFix "(in Werkzeug v2.3.x)") middleware for running behind Nginx:

```python
from werkzeug.middleware.proxy_fix import ProxyFix  
app.wsgi_app = ProxyFix(app.wsgi_app)
```

Wrapping `app.wsgi_app` instead of `app` means that `app` still points at your Flask application, not at the middleware, so you can continue to use and configure `app` directly.

**how to wrap app with nginx and how to deploy flask app behind nginx server. and build a reverse proxy.**

### Middleware

### Using Flask Extensions

Extensions are packages that help you accomplish common tasks. For example, Flask-SQLAlchemy provides SQLAlchemy support that makes it simple and easy to use with Flask.

For more on Flask extensions, see [Extensions](https://flask.palletsprojects.com/en/2.3.x/extensions/).

### Deploying to a Web Server

Ready to deploy your new Flask app? See [Deploying to Production](https://flask.palletsprojects.com/en/2.3.x/deploying/).

## Reference

- [Quickstart — Flask Documentation (2.3.x) (palletsprojects.com)](https://flask.palletsprojects.com/en/2.3.x/quickstart/#a-minimal-application)
