### qianngchn.github.io
A personal website on GitHub Pages

### Another
本站地址: <http://qianngchn.github.io>

#### Wiki
本站Wiki是基于Markdown + Pandoc + Makefile + Github搭建的在线Wiki，方法是用markdown写的文章，在本地建立起自己的知识架构，同时调用pandoc和makefile实现html的自动生成，然后再发布到Github上形成自己的在线Wiki。

这样做的好处在于，可以同时实现本地Markdown笔记和在线Wiki，笔记修改和发布极为方便。

### Help

1. 将.markdown文件分类放置在当前目录下
2. make all 根据.markdown文件生成索引和对应的html，并检查内链接是否存在
3. make index 根据.markdown文件生成索引
4. make check 检查.markdown文件内的内链接是否存在
5. make clean 清除所有html文件
