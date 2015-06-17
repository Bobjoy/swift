//
//  swifter.tips.swift
//  BTrip
//
//  Created by Vetech on 15/6/12.
//  Copyright (c) 2015年 BFL. All rights reserved.
//

import Foundation

class SwifterTips {
    
    
    class func testGCD() {
        // 创建目标队列
        let workingQueue = dispatch_queue_create("my_queue", nil)

        // 派发到刚创建的队列中，GCD会负责进行线程调度
        dispatch_async(workingQueue, { () -> Void in
            // 在workingQueue中异步进行
            println("努力工作")
            NSThread.sleepForTimeInterval(2)    // 模拟两秒的执行时间
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                // 返回到主线程更新UI
                println("结束工作，更新UI")
            })
        })
    }

    /**
    虽然我们最后将 pointer 值为 nil，但是由于 UnsafeMutablePointer 并不会自动进行内存管理，
    因此其实 pointer 所指向的内存是没有被释放和回收的 (这可以从 MyClass 的 deinit 没有被调用来加以证实；
    注意你需要在项目中运行内存相关的代码，Playground 是无法进行验证的)，这造成了内存泄露。
    正确的做法是为 pointer 加入 destroy 和 dealloc，它们分别会释放指针指向的内存的对象以及指针自己本身
    */
    class func testUnsafe() {
        var pointer: UnsafeMutablePointer<MyClass>!
        pointer = UnsafeMutablePointer.alloc(1)
        pointer.initialize(MyClass())

        println(pointer.memory.a)
        pointer.destroy()
        pointer.dealloc(1)
        pointer = nil
    }

}

class MyClass {
    var a = 1
    deinit {
        println("deinit")
    }
}