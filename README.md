### qianngchn.github.io
A personal website on GitHub Pages

### Homepage
本站地址: <http://qianngchn.github.io>

#### Wiki
本站Wiki是基于Markdown + Pandoc + Github搭建的在线Wiki，方法是用markdown写的文章，在本地建立起自己的知识架构，同时调用pandoc实现html的自动生成，然后再发布到Github上形成自己的在线Wiki。

这样做的好处在于，可以同时实现本地Markdown Wiki和在线Wiki，Wiki修改和发布极为方便。

### Help

1. 将markdown文件分类放置在当前目录下
2. make all 依次完成所有工作：编排索引，检查markdown内链接是否存在，生成对应的html
3. make index 根据markdown文件生成索引
4. make clean 清除所有html文件
