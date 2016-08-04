/*
 最快让你上手ReactiveCocoa之基础篇
 ------------------------------
 前言
 ---
 很多blog都说ReactiveCocoa好用，然后各种秀自己如何灵活运用ReactiveCocoa，但是感觉真正缺少的是一篇如何学习ReactiveCocoa的文章，小编看了很多篇都没看出怎么使用ReactiveCocoa,于是决定自己写一遍关于学习ReactiveCocoa的文章,本文主要针对如何从零开始学习ReactiveCocoa.
 
 
 
 
 1.ReactiveCocoa简介
 ------------------
 ReactiveCocoa（简称为RAC）,是由Github开源的一个应用于iOS和OS开发的新框架,Cocoa是苹果整套框架的简称，因此很多苹果框架喜欢以Cocoa结尾。
 
 
 
 
 2.ReactiveCocoa作用
 ------------------
 在我们iOS开发过程中，经常会响应某些事件来处理某些业务逻辑，例如按钮的点击，上下拉刷新，网络请求，属性的变化（通过KVO）或者用户位置的变化（通过CoreLocation）。但是这些事件都用不同的方式来处理，比如action、delegate、KVO、callback等。
 
 其实这些事件，都可以通过RAC处理，ReactiveCocoa为事件提供了很多处理方法，而且利用RAC处理事件很方便，可以把要处理的事情，和监听的事情的代码放在一起，这样非常方便我们管理，就不需要跳到对应的方法里。非常符合我们开发中高聚合，低耦合的思想。
 
 
 
 
 3.编程思想
 ------------------
 在开发中我们也不能太依赖于某个框架，否则这个框架不更新了，导致项目后期没办法维护，比如之前Facebook提供的Three20框架，在当时也是神器，但是后来不更新了，也就没什么人用了。因此我感觉学习一个框架，还是有必要了解它的编程思想。
 先简单介绍下目前咱们已知的编程思想。
 
 3.1 面向过程：处理事情以过程为核心，一步一步的实现。
 
 3.2 面向对象：万物皆对象
 
 3.3 链式编程思想：是将多个操作（多行代码）通过点号(.)链接在一起成为一句代码,使代码可读性好。a(1).b(2).c(3)
 
 链式编程特点：方法的返回值是block,block必须有返回值（本身对象），block参数（需要操作的值）
 
 代表：masonry框架。
 
 练习一:模仿masonry，写一个加法计算器，练习链式编程思想。
 
 3.4 响应式编程思想：不需要考虑调用顺序，只需要知道考虑结果，类似于蝴蝶效应，产生一个事件，会影响很多东西，这些事件像流一样的传播出去，然后影响结果，借用面向对象的一句话，万物皆是流。
 
 代表：KVO运用。
 
 练习二:KVO底层实现。
 
 3.5 函数式编程思想：是把操作尽量写成一系列嵌套的函数或者方法调用。
 
 函数式编程特点：每个方法必须有返回值（本身对象）,把函数或者Block当做参数,block参数（需要操作的值）block返回值（操作结果）
 
 代表：ReactiveCocoa。
 
 练习三:用函数式编程实现，写一个加法计算器,并且加法计算器自带判断是否等于某个值.
 
 
 
 
 4.ReactiveCocoa编程思想
 ---------------------
 ReactiveCocoa结合了几种编程风格：
 
 函数式编程（Functional Programming）
 
 响应式编程（Reactive Programming）
 
 所以，你可能听说过ReactiveCocoa被描述为函数响应式编程（FRP：The function of reactive programming）框架。
 
 以后使用RAC解决问题，就不需要考虑调用顺序，直接考虑结果，把每一次操作都写成一系列嵌套的方法中，使代码高聚合，方便管理。
 */
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

