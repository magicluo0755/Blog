# [译] 为什么需要可观测性

Infrastructure software is in the midst of a paradigm shift. Containers, orchestrators, microservices architectures, service meshes, immutable infrastructure, and functions-as-a-service (also known as “serverless”) are incredibly promising ideas that fundamentally change the way software is built and operated. As a result of these advances, the systems being built across the board—at companies large and small—have become more distributed, and in the case of containerization, more ephemeral.


基础软件正在经历范式转移。 容器、编排、微服务架构、服务网格、不可变基础设施和函数即服务（也称为 `Serverless`）都是非常有前景的想法，它们从根本上改变了软件的构建和操作方式。 由于这些进步，大大小小公司正在全面构建的系统变得更加分散，而在容器下，系统更加短暂。

Systems are being built with different reliability targets, requirements, and guarantees. Soon enough, if not already, the network and underlying hardware failures will be robustly abstracted away from software developers. This leaves software development teams with the sole responsibility of ensuring that their applications are good enough to make capital out of the latest and greatest in networking and scheduling abstractions.

正在构建的系统具有不同的可靠性目标、要求和保证。很快，若还没有的话，网络和底层的硬件故障将会从软件开发人员中完全抽象出来。这使得软件开发团队专注于确保所负责的应用程序足够好，并从最新且最最重要的网络和调度等技术抽象中获益。

In other words, better resilience and failure tolerance from off-the-shelf components means that—assuming said off-the-shelf components have been understood and configured correctly—most failures not addressed by application layers within the callstack will arise from the complex interactions between various applications. Most organizations are at the stage of early adoption of cloud native technologies, with the failure modes of these new paradigms still remaining somewhat nebulous and not widely advertised. To successfully maneuver this brave new world, gaining visibility into the behavior of applications becomes more pressing than ever before for software development teams.

换句话说，现有组件拥有更好弹性和故障容错能力，这意味着（假定上述现有组件被正确理解和配置）在应用层的调用栈中无法寻址定位的绝大多数故障，将在各种应用程序之间产生复杂的影响。

Monitoring of yore might have been the preserve of operations engineers, but observability isn’t purely an operational concern. This is a book authored by a software engineer, and the target audience is primarily other software developers, not solely operations engineers or site reliability engineers (SREs). This book introduces the idea of observability, explains how it’s different from traditional operations-centric monitoring and alerting, and most importantly, why it’s so topical for software developers building distributed systems.

以往的监控是运维工程师的专利，但是可观测性并不完全是一个运维问题。本书由软件工程师所编写，目标读者首先是其他软件工程师，不仅仅是运维工程师和网站可靠性工程师（`SREs`）。本书介绍了可观测性的概念，解释了与以监控和告警为中心的传统运维的不同，最重要的是，为什么它是构建分布式系统软件工程师的热门话题。


## 什么是可观测性

*Observability* might mean different things to different people. For some, it’s about logs, metrics, and traces. For others, it’s the old wine of monitoring in a new bottle. The overarching goal of various schools of thought on observability, however, remains the same—bringing better visibility into systems.

可观测性，不同的人有不同见解。对一些人而言，它就是日志、指标和链路。对其他人，则是监控这个概念的新瓶装旧酒。然而，不同思想流派派关于可观测性的总体目标仍然是一致的—为系统带来更好的可见性。


## 可观测性不只是日志、指标和追踪

Logs, metrics, and traces are useful tools that help with testing, understanding, and debugging systems. However, it’s important to note that plainly having logs, metrics, and traces does not result in observable systems.

>  日志、指标和链路是非常有用的工具，有助于测试、理解和调试系统。然而，需要注意的是，显然拥有日志、度量标准和跟踪并不会导致可观测的系统。

In its most complete sense, observability is a property of a system that has been designed, built, tested, deployed, operated, monitored, maintained, and evolved in acknowledgment of the following facts:

- No complex system is ever fully healthy.
- Distributed systems are pathologically unpredictable.
- It’s impossible to predict the myriad states of partial failure various parts of the system might end up in.
- Failure needs to be embraced at every phase, from system design to implementation, testing, deployment, and, finally, operation.
- Ease of debugging is a cornerstone for the maintenance and evolution of robust systems.

在完整的意义上，可观测性作为系统的一项特性，系统经过设计、构建、测试、部署、运维、监控、维护，发展，并承认以下事实：

- 复杂系统没有一个是完全健康的
- 分布式系统根本具有病态的不可预测性
- 不可能预测系统的各个部分最终可能出现的无数种局部故障状态
- 每个阶段都要接受失败，从系统的设计到实现、测试、部署以及运维
- 易于调试是稳固系统可维护和发展的基石



**可观测性的更多面孔**

The focus of this report is on logs, metrics, and traces. However, these aren’t the only observability signals. Exception trackers like the open source [Sentry](https://github.com/getsentry/sentry) can be invaluable, since they furnish information about thread-local variables and execution stack traces in addition to grouping and de-duplicating similar errors or exceptions in the UI.

本报告的重点是日志、指标和追踪信息。然而，这些并不是唯一的可观测性信号。像开源 [Sentry](https://github.com/getsentry/sentry)这样的异常追踪器是非常有价值的，因为它们除了在UI中分组和去重复删除类似的错误或异常之外，它们还提供了关于线程-本地变量和执行堆栈跟踪的信息。

Detailed profiles (such as CPU profiles or mutex contention profiles) of a process are sometimes required for debugging. This report does not cover techniques such as [SystemTap](https://en.wikipedia.org/wiki/SystemTap) or [DTrace](https://en.wikipedia.org/wiki/DTrace), which are of great utility for debugging standalone programs on a single machine, since such techniques often fall short while debugging distributed systems as a whole.

调试时有时需要进程的详细配置文件（如CPU配置文件或互斥竞争配置文件）。本报告并不包含诸如 [SystemTap](https://en.wikipedia.org/wiki/SystemTap) 或 [DTrace](https://en.wikipedia.org/wiki/DTrace)这些在单一的机器上的运行单机程序的调试工具，因为这些技术通常在调试整体的分布式系统时显得不足。



Also outside the scope of this report are formal laws of performance modeling such as [universal scalability law](http://bit.ly/2sa2QpX), [Amdahl’s law](https://en.wikipedia.org/wiki/Amdahl's_law), or concepts from [queuing theory](https://speakerdeck.com/emfree/queueing-theory) such as [Little’s law](http://bit.ly/2KO6pLb). Kernel-level [instrumentation techniques](https://www.kernel.org/doc/Documentation/kprobes.txt), [compiler inserted instrumentation points](https://llvm.org/docs/XRay.html) in binaries, and so forth are also outside the scope of this report.


## 可观测性不完全是运维问题

An observable system isn’t achieved by plainly having monitoring in place, nor is it achieved by having an SRE team carefully deploy and operate it.

Observability is a feature that needs to be enshrined into a system at the time of system design such that:

- A system can be built in a way that lends itself well to being tested in a [realistic manner](http://bit.ly/2FYBYhG) (which involves a certain degree of testing in production).
- A system can be tested in a manner such that any of the hard, actionable failure modes (the sort that often result in alerts once the system has been deployed) can be surfaced during the time of testing.
- A system can be deployed incrementally and in a manner such that a rollback (or roll forward) can be triggered if a key set of metrics deviate from the baseline.
- And finally, post-release, a system can be able to report enough data points about its health and behavior when serving real traffic, so that the system can be understood, debugged, and evolved.

None of these concerns are orthogonal; they all segue into each other. As such, observability isn’t purely an operational concern.

一个可观测的系统不是通过明确的监控来实现的，也不是通过让一个SRE团队仔细部署和运维它来实现的。

可观测性作为一个特性需要在系统设计之初就内置其中，诸如：

- 系统可以通过一种易于在realistic manner测试（包括在生产环境中一定程度的测试）的方式进行构建。
- 系统可以以这样一种方式进行测试：任何困难的、可操作的故障模式（一旦系统部署后经常导致警报的类型都可以在测试期间出现）。
- 系统可迭代部署，在一定程度上诸如一些关键指标集偏离基线，就可以触发回滚（或前滚）。
- 最后，在发布后，当系统处理真实流量时候，可以报告最够多的数据表明其健康和运行状况，因此该系统可以被了解，调试和发展演变。

这些都不是割裂的，它们彼此之间相互融合。因此，可观察性并不纯粹是一个运维问题。



## 结论

可观测性与监控并不相同，但是是否意味着监控已死？在下一章，我们将讨论为什么可观测性不能排除监控的需要，以及监控的一些最佳实践。

