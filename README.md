# vuepress-theme-zjblog
这个vuepress主题是我在[vuepress-theme-yubisaki](https://github.com/Yubisaki/vuepress-theme-yubisaki)这个主题之上
进行修改而来的,原来的这个主题就非常好,只是我想加了一点我想要的内容和改了一点小问题,我搭建的博客[猿码集](https://zjblog.github.io/)为了能自动打包,所以才上传npm的.
## 新加内容
* 增加了百度的自动推送功能
* 增加了个人感觉好玩的footer
* 增加了一个card用来展示微信公众号
* 增加二维码，手机扫码阅读
* 修改了评论会初始化两次的问题(偶尔会出现)
* 把GithubCard页面的请求去掉了
* 修改404页面样式
* 如果不设置背景图地址就每次随机一张图片作为背景图
* 修改分页的问题
* 增加友情链接配置
* 修改生成二维码链接为https
* 修改分页在tags显示的问题
* 使用actions自动部署到npm
* 增加获取随机图片的配置
## 新增的配置
```js
themeConfig:{
  //footer上显示的邮箱地址
  zjemail: '',
  //footer上显示的github地址
  zjgithub: '',
  //footer上显示的stackoverflow地址
  zjoverflow:'',
  //新增展示的微信二维码
  zjwx: '',
  //把title和首页的标题区分开了,这是首页logo旁边的字
  zjHome: '',
  //友情链接
  zjurl:[{url:'https://www.bangechengzi.com/',name:'半个橙子'}],
  //每日一张随机图片地址
  backgroundUrl: 'https://www.bangechengzi.com/img/'
}
```

## 配置说明
 * 其它配置请参考[vuepress-theme-yubisaki](https://github.com/Yubisaki/vuepress-theme-yubisaki)这个主题的配置
     * [说明文档](https://github.com/Bloss/vuepress-theme-yubisaki/blob/master/README.md)
     * [中文说明](https://wuwaki.me/yubisaki/usage.html)
----
__再次感谢[vuepress-theme-yubisaki](https://github.com/Yubisaki/vuepress-theme-yubisaki)的作者__
