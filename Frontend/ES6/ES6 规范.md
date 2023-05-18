# Webstorm
- [合理使用WebStorm-环境配置篇 - 掘金 (juejin.cn)](https://juejin.cn/post/6987411282274025485)
- github 教程

# let
1. let 不能重复声明
2. 块级作用域， 全局，函数，eval ---> 动态调用，其实很早就有这样的想法了。
3. 不存在变量提升
4. 不影响作用域链

# const
1. 一定要赋初值
2. 一般常量使用大写(潜规则)
3. 常量的值不能修改
4. 块级作用域
5. 数组地址没有改变，所以对元素进行修改可以
	1. const TEAM = ['UZI','MLXG'];
	2. TEAM.push('changzhang');
	3. 数组的首地址没有发生改变

# 变量结构赋值
- 数组解构写法
- 对象解构写法
	- const zhao = {}
	- let (xiaopin) = zao; 利用方法名获取方法 。

# 模板字符串
- 单引号、双引号、**反引号**
1. 内容中可以直接出现换行符


# 简化对象写法
```js
	let name = 'zhangce';
	let change = function(){
		console.log('we can chaange you')
	}

	const school = {
		name,
		change,
		invoke(){
			consolle.log('invoke')
		}
	}
```
# 箭头函数
```js
	let fn = (para1, para2)=>{
		return para1, para2
	}

	fn(1,2);
```
- this 静态的，this 始终指向函数声明时所在作用域下 this 的值。
- call 方法可以改变函数内部 this 的值。

![[Pasted image 20221111071000.png]]

1. 不能作为构造函数赋值
![[Pasted image 20221111071118.png]]
- 不能使用 arguments 变量
 ![[Pasted image 20221111071158.png]]
- 箭头函数的简写
	- 小括号 一个参数
	- 花括号 一条代码
![[Pasted image 20221111071346.png]]

- 箭头函数的应用
```js
    let item = document.getElementById("ad");
	item.addEventListener("click",function () {
		// let _this = this

		setTimeout( ()=>{
			this.style.background = 'pink';
		}, 2000)
	})
	const arr = [1,4,5,6,7,8,9,10,11,12,13,14];
	// const result = arr.filter(function (item) {
	//     if (item%2==0) {
	//         return true;
	//     } else {
	//         return false;                
	//     }
	// })
	const result = arr.filter(item => item%2===0)
```


![[Pasted image 20221111073226.png]]
- 箭头函数适合与 this 无关的回调，定时器，数组方法回调。
- 箭头头函数不适合与  this 有关的回调，事件问题，对象的方法。
