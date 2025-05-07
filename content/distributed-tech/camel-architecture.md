---
author : "老罗"
title : " 1.4 Camel的架构"
date : 2025-05-07
description : "《Apache Camel in Action 2nd》第1章1.4至1.6节全部的中文翻译"
tags : [
    "Camel",
]
categories : [
    "iPaaS",
]

toc : true
---

你将首先了解高层架构，然后深入探讨具体概念。读完本节后，你应该已经熟悉了集成领域的术语，并为第2章做好准备，在那里你将探索 Camel 的路由功能。


## 整体架构
我们认为，架构最好先从高层次视角进行审视。图1.8展示了构成 Camel 架构的主要概念的高层视图。

![Camel整体架构](/assets/camel/c01_08.png)
图1.8 

路由引擎使用路由作为规范，指示消息的路由方向。路由（`Route`）通过 Camel 的领域特定语言（DSL）之一进行定义。处理器（`Processor`）用于在路由过程中转换和操作消息，并实现所有企业集成模式（EIP），这些模式在 DSL 中有对应的名称。组件（`Component`）是 Camel 中用于连接其他系统的扩展点。为了将这些系统暴露给 Camel 的其他部分，组件提供了端点（`Endpoint`）接口。

在了解了高层次视图后，让我们更仔细地介绍 1.8 中的各个概念。


## Camel的概念

图 1.8 揭示了许多新概念，因此让我们逐一仔细探讨。我们将从 CamelContext 开始，它是 Camel 的运行时。图 1.9 展示了 CamelContext 整合的最重要服务。

图1.9 `CamelContex`t 提供了对许多有用服务的访问，其中最值得注意的服务包括组件（`components`）、类型转换器（`type converters`）、注册表（`registry`）、端点（`endpoints`）、路由（`routes`）、数据格式（`data formats`）和语言（`languages`）。

![CamelContext](/assets/camel/c01_09.png)

正如你所见，`CamelContext` 需要跟踪许多服务。这些服务在表 1.1 中进行了描述。

| 服务                          | 描述                                                                                                                                                                                                                                                 |
| ----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 组件(`Componentes`)           | 包含使用的组件。Camel 能够通过类路径上的自动发现或在 OSGi 容器中激活新 bundle 时动态加载组件。第 6 章将更详细地讨论组件。                         |
| 端点(`Endpoints`)             | 包含已使用的端点。                                                                                                                                                                                                         |
| 路由(`Routes`)                | 包含已加入的路由.路由将在第2章讨论。                                                                                                                                                                                  |
| 类型转换器(`Type converters`) | 包含已加载的类型转换器。Camel 提供了一种机制，允许你手动或自动将一种类型转换为另一种类型。类型转换器将在第 3 章中讨论。                                                                  |
| 数据格式(`Data formats`)      | 包含已加载的数据格式。数据格式将在第 3 章中讨论。
                                                                                                                                                                             |
| 注册表(`Registry`)            | 包含一个注册表，允许你查找 Bean。我们将在第 4 章中讨论注册表。                                                                                                                                                               |
| 语言(`Language`)              | 包含已加载的语言。Camel 允许你使用多种语言来创建表达式。你很快就会看到 XPath 语言的一个示例。附录 A 提供了 Camel 自己的 Simple 表达式语言的完整参考。 |

每个服务的细节将在本书中逐步讨论。现在让我们来看看路由和 Camel 的路由引擎。

### 路由引擎

Camel 的路由引擎是消息在幕后移动的核心机制。这个引擎对开发者来说是透明的，但你需要知道它的存在，它承担了所有繁重的工作，确保消息被正确路由。

### 路由

路由显然是 Camel 的核心抽象。最简单的定义是，路由是一系列处理器的链。在消息应用程序中使用路由有许多原因。通过将客户端与服务器、生产者与消费者解耦，路由可以实现以下功能：

- 动态决定客户端将调用哪个服务器

- 提供灵活的方式添加额外的处理逻辑

- 允许客户端和服务器独立开发

- 通过连接各司其职的独立系统，促进更好的设计实践

- 增强某些系统的功能和特性（如消息代理和企业服务总线）

- 允许在测试时通过模拟（mock）来替换服务器的客户端

Camel 中的每个路由都有一个唯一标识符，用于日志记录、调试、监控以及启动和停止路由。路由还精确地绑定到一个消息输入源，因此它们实际上与一个输入端点（endpoint）相关联。尽管如此，Camel 提供了一些语法糖（syntactic sugar），允许单个路由拥有多个输入源。例如，以下路由：

```java
from("jms:queue:A", "jms:queue:B", "jms:queue:C").to("jms:queue:D");
```
在底层，Camel 将路由定义克隆为三个独立的路由。因此，它的行为类似于以下三个独立的路由：

```java
from("jms:queue:A").to("jms:queue:D");
from("jms:queue:B").to("jms:queue:D");
from("jms:queue:C").to("jms:queue:D");
```

尽管在 Camel 2.x 中使用多个输入源的路由是完全合法的，但我们不推荐这样做。这一功能将在 Camel 的下一个主要版本中移除。为了定义这些路由，我们使用领域特定语言（DSL）。

### 领域特定语言

为了将处理器和端点连接在一起形成路由，Camel 定义了一个领域特定语言（DSL）。这里的 DSL 一词使用得有些宽松。在 Camel 中，DSL 指的是一个流畅的 Java API，其中包含以企业集成模式（EIP）术语命名的方法。

考虑以下示例：

```java
from("file:data/inbox")
    .filter().xpath("/order[not(@test)]")
    .to("jms:queue:order");

```
在这个单一的 Java 语句中，你定义了一个路由，该路由从文件端点消费消息。然后，消息被路由到过滤器（filter）EIP，该过滤器使用 XPath 谓词来测试消息是否不是测试订单。如果消息通过测试，它将被转发到 JMS 端点。未通过过滤器测试的消息将被丢弃。

Camel 提供了多种 DSL 语言，因此你可以使用 XML DSL 以如下方式定义相同的路由：

```xml
<route>
  <from uri="file:data/inbox"/>
  <filter>
    <xpath>/order[not(@test)]</xpath>
    <to uri="jms:queue:order"/>
  </filter>
</route>
```
### 处理器

处理器（`Processor`）是 Camel 的核心概念，表示一个能够使用、创建或修改传入交换（`exchange`）的节点。在路由过程中，交换从一个处理器流向另一个处理器；因此，你可以将路由视为一个图，其中专门的处理器作为节点，连接线表示一个处理器的输出连接到另一个处理器的输入。处理器可以是企业集成模式（`EIP`）的实现、特定组件的生产者，或者你自己的自定义创建。图 1.10 展示了处理器之间的流动。

![processor](/assets/camel/c01_10.png)

路由首先从一个消费者（在 DSL 中对应“from”）开始，消费者负责填充初始的交换（exchange）。在每个处理器步骤中，前一步的输出消息成为下一步的输入消息。在许多情况下，处理器不会设置输出消息，因此输入消息会被重用。在路由的末尾，交换的消息交换模式决定是否需要向路由的调用者返回回复。如果 MEP 是 `InOnly`，则不会返回回复。如果是 `InOut`，Camel 将从最后一步获取输出消息并返回。

>**注意:**
>在 Camel 中，生产者（Producers）和消费者（Consumers）的概念最初可能有些违反直觉。毕竟，生产者不应该是路由的第一个节点，而消费者不应该是在路由末尾消费消息吗？不用担心——你不是第一个这样想的人！只需从与外部系统通信的角度来理解这些概念。消费者从外部系统消费消息并将其带入路由。相反，生产者向外部系统发送（生产）消息。
>

交换（`exchange`）是如何进入或离开这个处理器图的？要弄清楚这一点，你需要了解组件（`components`）和端点（`endpoints`）。

### 组件
组件（Components）是 Camel 的主要扩展点。目前，Camel 生态系统拥有超过 280 个组件，功能涵盖数据传输、领域特定语言（DSL）、数据格式等。你甚至可以为 Camel 创建自己的组件——我们在第 8 章中讨论了这一点。

从编程的角度来看，组件相当简单：它们与 URI 中使用的名称相关联，并充当端点的工厂。例如，FileComponent 在 URI 中被称为 file，它创建 FileEndpoint。端点在 Camel 中可能是一个更基础的概念。

### 端点

端点（Endpoint）​ 是 Camel 对消息通道终端的抽象模型，系统通过它发送或接收消息。如图 1.11 所示。

图1.11

![endpoint](/assets/camel/c01_11.png)

在camel中，通过使用URIs来设置端点，例如`file:data/inbox?delay=5000`，并且也以这种方式引用端点。在运行时，camel基于URI标识符来查找端点。图1.12展示了其工作原理。

图1.12
![How endpoint works](/assets/camel/c01_12.png)


URI 中的模式（`scheme`）❶ 指定了处理该类型端点的 Camel 组件。在这个例子中，file 模式选择了 FileComponent。FileComponent 随后作为工厂根据 URI 的其余部分创建 FileEndpoint。上下文路径 `data/inbox` ❷ 告诉 FileComponent 起始文件夹是 `data/inbox`。选项 `delay=5000` ❸ 表示文件应以 5 秒的间隔进行轮询。

端点的功能远不止表面看起来那么简单。图 1.13 展示了端点如何与交换、生产者和消费者协同工作。初看图 1.13 可能显得有些复杂，但几分钟后你就会明白它的含义。简而言之，端点充当创建消费者和生产者的工厂，这些消费者和生产者能够向特定端点接收和发送消息。我们在图 1.8 的 Camel 高层视图中没有提到生产者和消费者，但它们是重要的概念，接下来我们将详细讨论它们。


### 生产者
生产者（Producer）是 Camel 的抽象概念，指能够向端点发送消息的实体。图 1.13 展示了生产者与其他 Camel 概念的配合关系。

当消息被发送到端点时，生产者负责处理使消息数据与特定端点兼容的细节。例如，FileProducer 会将消息主体写入文件。另一方面，JmsProducer 会将 Camel 消息映射到 `javax.jms.Message`，然后发送到 JMS 目标。这是 Camel 的一个重要特性，因为它隐藏了与特定传输协议交互的复杂性。你只需将消息路由到端点，生产者就会完成繁重的工作。

图1.13 端点如何与生产者，消费者和交换协同工作
![Producer](/assets/camel/c01_13.png)


### 消费者

消费者是接收由外部系统产生的消息、将其封装到交换中并发送到 Camel 进行处理的服务。消费者是 Camel 中被路由的交换的来源。

回顾图 1.13，你可以看到消费者与其他 Camel 概念的配合关系。为了创建新的交换，消费者会使用端点来封装被消费的负载。然后，通过路由引擎使用处理器来启动交换在 Camel 中的路由。
Camel 有两种消费者：事件驱动消费者（`event-driven consumers`）和轮询消费者（`polling consumers`）。这两种消费者之间的差异很重要，因为它们解决了不同的问题。

### 事件驱动型消费者

最熟悉的消费者可能是事件驱动型消费者，如图 1.14 所示。

图1.14 事件驱动消费者
![Event driven consumer](/assets/camel/c01_14.png)

这种消费者主要与客户端-服务器架构和 Web 服务相关联。在企业集成模式领域中，它也被称为异步接收者。事件驱动消费者监听特定的消息通道，例如 TCP/IP 端口、JMS 队列、Twitter 句柄、Amazon SQS 队列、WebSocket 等。然后，它等待客户端向其发送消息。当消息到达时，消费者会被唤醒并接收消息进行处理。

### 轮询型消费者

另外一种消费者是轮询消费者（`Polling Consumer`）,如图1.15所示。

图1.15 轮询消费者主动检查新的消息
![polling consumer](/assets/camel/c01_15.png)

与事件驱动型消费者不同，轮询消费者会主动从特定源（如FTP服务器）获取消息。在企业集成模式（EIP）术语中，轮询消费者也被称为`同步接收器`，因其在处理完当前消息前不会发起新的轮询操作。其中最常见形式是`定时轮询消费者`，它按照预定的时间间隔执行轮询。文件组件、FTP组件和电子邮件组件均采用这种定时轮询机制。

至此，我们已完整介绍了Camel的核心概念。基于这些知识，您现在可以重新审视最初的Camel示例，深入理解其运行原理。

## 回顾最初的Camel示例

让我们回顾您在1.2.2节首次接触的Camel示例：从一个目录（data/inbox）读取文件，并将处理结果写入另一个目录（data/outbox）。现在，基于您已掌握的Camel核心概念，我们可以更深入地理解这个示例的实现原理。

请参阅以下代码清单中的Camel应用程序实现：

```java
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;

public class FileCopierWithCamel {

    public static void main(String args[]) throws Exception {
        CamelContext context = new DefaultCamelContext();
        context.addRoutes(new RouteBuilder() {
            public void configure() {
                from("file:data/inbox?noop=true").to("file:data/outbox");     #1
            }
        });
        context.start();                         
        Thread.sleep(10000);
        context.stop();
    }
}

#1 Java DSL route
```
在这个示例中，您首先创建了CamelContext——这是Camel的运行时环境。然后通过RouteBuilder和Java DSL（如标注❶所示）添加路由逻辑。使用DSL可以让您以清晰简洁的方式，让Camel自动实例化组件、端点、消费者、生产者等对象。您只需专注于定义对集成项目至关重要的路由规则即可。

不过底层实现上，Camel会访问FileComponent，并将其作为工厂来创建端点及其生产者。同样的FileComponent也会被用来创建消费者端的实例。

## 总结

本章中，我们初步认识了 ​Apache Camel。您了解到 Camel 如何通过企业集成模式（EIPs）​ 简化系统集成，并体验了其领域专用语言（DSL）​ 如何让代码具备自解释性——开发者只需关注"做什么"，而非"如何实现"。

我们系统梳理了 Camel 的核心特性、适用场景与边界，演示了它如何通过统一的抽象层和 API 兼容多种协议与数据格式。至此，您应已掌握 Camel 的核心价值与设计理念，为后续理解实际应用打下基础。

在本书后续章节中，我们将深入探索 Camel 的实战功能，剖析其"坚硬外壳"下的运行机制。为确保知识吸收，每章小结将提炼最佳实践与关键要点。

下一章我们将研究 Camel 的核心乐趣所在：​路由（Routing）​——这一功能既至关重要，又充满学习趣味。
