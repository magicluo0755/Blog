---
layout: post
title : " 可观测性的必要性(译文)"
description : "本文翻译自Oreilly出版的电子书《Distributed systems Observability》(By Cindy Sridharan)第一章"
excerpt: "本文翻译自Oreilly出版的电子书《Distributed systems Observability》(By Cindy Sridharan)第一章"
author : "Laurence"
date : 2023-11-27 09:00:00
image: "img/post-bg-unix-linux.jpg"
tags : 
  - 可观测性
  - 译文
categories : 
  - 分布式架构
showtoc : true
---

![Distributed-Systems-Observability](/assets/tech/Distributed-Systems-Observability.jpg)

> 本文翻译自上述Oreilly出版的电子书《Distributed systems Observability》(By Cindy Sridharan)第一章。


基础软件正在经历范式转移。 容器、编排、微服务架构、服务网格、不可变基础设施和函数即服务（也称为 `Serverless`）都是非常有前景的想法，它们从根本上改变了软件的构建和操作方式。 由于这些进步，大大小小公司正在全面构建的系统变得更加分散，而在容器下，系统更加短暂。

正在构建的系统具有不同的可靠性目标、要求和保证。很快，若暂时还没有，网络和底层的硬件故障将会从软件开发人员中完全抽象出来。这使得软件开发团队专注于确保所负责的应用程序足够好，并从最新且最最重要的网络和调度等技术抽象中获益。

换句话说，现有组件拥有更好弹性和故障容错能力，这意味着（假定上述现有组件被正确理解和配置）在应用层的调用栈中无法寻址定位的绝大多数故障，将在各种应用程序之间产生复杂的影响。

以往的监控是运维工程师的专利，但是可观测性并不完全是一个运维问题。本书由软件工程师所编写，目标读者首先是其他软件工程师，不仅仅是运维工程师和网站可靠性工程师（`SREs`）。本书介绍了可观测性的概念，解释了它与以监控和告警为中心的传统运维的不同，最重要的是，为什么它是构建分布式系统软件工程师的热门话题。

### 什么是可观测性

**可观测性**，不同的人有不同理解。一些人认为它就是日志、指标和链路，有一些则认为是监控这个概念的新瓶装旧酒。然而，不同思想流派关于可观测性的总体目标仍然是一致的—为系统带来更好的可见性。

**可观测性不只是日志、指标和追踪**

>  日志、指标和链路是非常有用的工具，有助于测试、理解和调试系统。然而需要注意的是，显然拥有日志、度量标准和跟踪并不会具有可观测性的系统。

在完整的意义上，可观测性是作为系统的一项特性，系统经过设计、构建、测试、部署、运维、监控、维护，发展，并承认以下事实：

- 复杂系统没有一个是完全健康的
- 分布式系统根本具有病态的不可预测性
- 不可能预测系统的各个部分最终可能出现的无数种局部故障状态
- 每个阶段都可能失败，从系统的设计到实现、测试、部署以及运维
- 易于调试是稳固系统可维护和发展的基石

**可观测性的更多面孔**

本文的重点是日志、指标和追踪信息，然而这些并不是唯一的可观测性信号。像开源 [Sentry](https://github.com/getsentry/sentry)这样的异常追踪器是非常有价值的，因为它们除了在UI中分组和去重复删除类似的错误或异常之外，它们还提供了关于线程-本地变量和执行堆栈跟踪的信息。

调试时有时需要进程的详细配置文件（如CPU配置文件或互斥竞争配置文件）。本文不包含诸如 [SystemTap](https://en.wikipedia.org/wiki/SystemTap) 或 [DTrace](https://en.wikipedia.org/wiki/DTrace)这些在单独主机上的运行单机程序的调试工具的相关技术，因为这些技术通常在调试整体的分布式系统时显得不足。

同样在本文范围之外的还有正式的性能建模定律，如[通用的可扩展性定律](http://bit.ly/2sa2QpX)、[Amdahl定律](https://en.wikipedia.org/wiki/Amdahl's_law)，或者是[队列论](https://speakerdeck.com/emfree/queueing-theory)中的概念，比如[利特尔定律](http://bit.ly/2KO6pLb)。[内核级检测技术](https://www.kernel.org/doc/Documentation/kprobes.txt)、二进制文件[编译器插入的桩点](https://llvm.org/docs/XRay.html)等也不在本文的范围之内。

### 可观测性不完全是运维问题

一个可观测的系统不是通过明确的监控来实现的，也不是通过让一个SRE团队仔细部署和运维它来实现的。可观测性作为一个特性需要在系统设计之初就内置其中，诸如：
- 系统可以通过一种易于在realistic manner测试（包括在生产环境中一定程度的测试）的方式进行构建
- 系统可以以这样一种方式进行测试：任何困难的、可操作的故障模式（一旦系统部署后经常导致警报的类型都可以在测试期间出现）
- 系统可迭代部署，在一定程度上诸如一些关键指标集偏离基线，就可以触发回滚（或前滚）
- 最后，在发布后，当系统处理真实流量时候，可以报告最够多的数据表明其健康和运行状况，因此该系统可以被了解，调试和发展演变

这些都不是割裂的，它们彼此之间相互融合。因此，可观察性并不纯粹是一个运维问题

### 结论
可观测性与监控并不相同，但是是否意味着监控已死？在下一章，我们将讨论为什么可观测性不能排除监控的需要，以及监控的一些最佳实践。



> 附原文:[ https://learning.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch01.html]( https://learning.oreilly.com/library/view/distributed-systems-observability/9781492033431/ch01.html)