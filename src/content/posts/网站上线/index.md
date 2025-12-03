---
title: 网站上线
published: 2025-11-23
description: "现在可以通过ziyang.site来访问本站啦！以及，发现了fuwari中一个与默认主题色相关的漏洞"
image: "./cover.png"
tags: ["记录", "漏洞"]
category: 更新
draft: false
---
> [うえのみぎ](https://www.pixiv.net/users/37886530)老师绘制的插图，详见[Pixiv](https://www.pixiv.net/artworks/121356693)

### 概况

正如description所言，现在可以通过`ziyang.site`来访问本站啦

弄到一个性价比不错且非常简洁的域名(≧∇≦)

选择了`Cloudflare`作为部署平台，因为免费且国内大概率能直连 :spoiler[虽然你站四天前才炸过(]

### 我错了。

开始为了实现某些效果乱改fuwari的代码 导致出现了不少诡异的问题（

包括但不限于banner不显示、调色盘不工作、search框消失...

修不好的问题都通过重新克隆仓库解决了 相应也放弃了一些东西 :spoiler[再也不乱改了呜呜（x]

### 也许是漏洞

起初我以为也是因为乱改出的问题，直到重新克隆仓库后仍存在...

发现了一个默认主题色相关的漏洞：

只有首次启动页面的时候程序会从`config.ts`获取默认主题色`hue`数值，在此之后无论如何改变`hue`默认主题色都不再改变

翻了翻源码，问题出在`src\utils\setting-utils.ts`中下面这一段：

```JavaScript
export function getHue(): number {
	const stored = localStorage.getItem("hue");
	return stored ? Number.parseInt(stored, 10) : getDefaultHue();
}
```

在初次读取后，`localStorage`中始终存在一个有效的`hue`值，从而导致`getDefaultHue()`永远不会被调用，所以默认主题色此后不会再刷新

虽然如果永不改变默认主题色，页面就不会因此出破绽，但谁又能保证呢.

如果问题确实如此，我也许该试试怎么在github上上传issue

### 最后的话

其实感觉这样发帖不是特别方便，特别是如果夹带图片资源

也许有时间可以试着搓一个`post-editor`？ 先画个饼吧（

‍

好的那么

下次再见各位≧∇≦)



