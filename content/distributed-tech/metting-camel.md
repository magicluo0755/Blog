---
author : "老罗"
title : " 初识Camel"
date : 2025-05-07
description : "Apache Camel in Action 2书籍的第1章1.1至1.4节中文翻译"
tags : [
    "Camel",
]
categories : [
    "iPaaS",
]

toc : true
---

> **本章内容包括**：
> - Camel简介
> - Camel的主要功能
> - 你的第一次Camel体验
> - Camel的架构与概念

从头构建复杂系统是一项成本高昂且几乎从不成功的任务。一个更有效且风险较低的替代方案是将系统像拼图一样从现有的、经过验证的组件中组装起来。我们每天依赖许多这样的集成系统，从电话通信、财务交易、医疗保健到旅行规划和娱乐，一切皆有可能。

拼图游戏需要一整套能够简单、无缝且稳健地相互连接的拼图块，系统集成项目也是如此。然而，与拼图块天生适合相互连接不同，我们集成的系统很少是为此设计的。集成框架旨在填补这一差距。作为一名开发者，你不太关心集成的系统内部如何工作，而更专注于如何从外部与它交互。一个好的集成框架为复杂的系统提供简单、可管理的抽象，并提供将它们无缝连接在一起的“胶水”。

Apache Camel 就是这样一个集成框架。在本书中，我们将帮助你理解 Camel 是什么、如何使用它，以及为什么我们认为它是最好的集成框架之一。本章首先介绍 Camel 并突出其核心功能。然后我们将介绍 Camel 的发行版，并解释如何运行本书中的 Camel 示例。我们将通过介绍核心 Camel 概念来结束本章，以便你能理解 Camel 的架构。

准备好了吗？让我们来认识 Camel。

# 介绍Camel

Camel 是一个集成框架，旨在让你的集成项目高效且有趣。Camel 项目始于2007年初，现在是一个成熟的开源项目，采用宽松的 Apache 2 许可证，拥有强大的社区支持。

Camel 的重点在于简化集成。我们相信当你读完本书后，你会欣赏 Camel 并将其列入你的必备工具清单。

这个 Apache 项目被命名为 Camel，因为这个名字简短且易于记忆。有传言说，这个名字可能受到一位创始人曾经抽过的 Camel 香烟的启发。在 Camel 网站上的常见问题解答页面([http://camel.apache.org/why-the-name-camel.html](http://camel.apache.org/why-the-name-camel.html))中，列出了其他一些关于命名的轻松理由。

## 什么是Camel

Camel 框架的核心是一个路由引擎，或者更准确地说，是一个路由引擎构建器。它允许你定义自己的路由规则，决定从哪些源接受消息，以及如何处理这些消息并将其发送到其他目标。Camel 使用一种集成语言，让你可以定义复杂的路由规则，类似于业务流程。如图1.1所示，Camel 充当了不同系统之间的“胶水”。

Camel 的一个基本原则是它不对需要处理的数据类型做任何假设。这是一个重要的特点，因为它为开发者提供了机会，可以集成任何类型的系统，而无需将数据转换为标准格式。

![Camel is the glue between disparate systems](/assets/camel/c01_01.png)

Camel 提供了更高层次的抽象，使你能够使用统一的 API 与各种系统交互，而无需考虑系统使用的协议或数据类型。Camel 中的组件提供了针对不同协议和数据类型的 API 具体实现。开箱即用，Camel 支持超过 280 种协议和数据类型。其可扩展和模块化的架构允许你实现并无缝插入对自定义协议的支持，无论是专有协议还是其他协议。这些架构选择消除了不必要的转换需求，使 Camel 不仅更快，而且更精简。因此，它适合嵌入到需要 Camel 丰富处理能力的其他项目中。其他开源项目，如 `Apache ServiceMix`、`Karaf` 和 `ActiveMQ`已经使用 Camel 作为集成手段。

我们还应该澄清 Camel 不是什么。Camel 不是企业服务总线（ESB），尽管有些人因其支持路由、转换、编排、监控等功能而称其为轻量级 ESB。Camel 没有容器或可靠的消息总线，但它可以部署在这样的环境中，例如前面提到的 `Apache ServiceMix`。因此，我们更倾向于将 Camel 称为集成框架而非 ESB。

如果提到 ESB 让你想起庞大而复杂的部署，不用担心。Camel 在小型部署中同样表现出色，例如微服务或物联网（IoT）网关。

为了理解 Camel 是什么，让我们来看看它的主要功能。

## 为什么使用Camel
Camel 在集成领域引入了一些新颖的理念，这也是其创始人最初创建 Camel 的原因。我们将在本书中深入探讨 Camel 的丰富功能，以下是 Camel 的核心概念：

- 路由和中介引擎

- 广泛的组件库

- 企业集成模式（EIP）

- 领域特定语言（DSL）

- 与负载无关的路由器

- 模块化和可插拔架构

- 普通 Java 对象（POJO）模型

- 简单配置

- 自动类型转换器

- 轻量级核心，适合微服务

- 云就绪

- 测试套件

- 活跃的社区

我们将逐一详细探讨这些功能。

**路由和中介引擎**

Camel 的核心功能是其路由和中介引擎。路由引擎根据路由配置选择性地移动消息。在 Camel 中，路由通过企业集成模式和领域特定语言的组合进行配置，我们接下来将对此进行描述。

**广泛的组件库**

Camel 提供了超过 280 种组件的广泛库。这些组件使 Camel 能够通过传输协议进行连接、使用 API 并理解数据格式。尝试在图 1.2 中找出你过去使用过或未来想使用的技术。当然，本书无法涵盖所有这些组件，但我们会详细介绍大约 20 种最常用的组件。如果你对某个特定组件感兴趣，可以查阅索引。

![Camel支持超过280个转换器](/assets/camel/c01_02.png)

**企业集成模式**

尽管集成问题各不相同，Gregor Hohpe 和 Bobby Woolf 注意到许多问题及其解决方案却非常相似。他们在《企业集成模式》（Addison-Wesley, 2003）一书中对这些问题进行了分类，这本书是每位集成专业人士的必读之作[www.enterpriseintegrationpatterns.com]（www.enterpriseintegrationpatterns.com）。如果你还没读过，我们强烈推荐你阅读。至少，它能帮助你更快、更轻松地理解 Camel 的概念。

企业集成模式（EIPs）之所以有用，不仅因为它们为特定问题提供了经过验证的解决方案，还因为它们有助于定义和沟通问题本身。模式具有已知的语义，这使得问题沟通变得更加容易。Camel 高度基于 EIPs。尽管 EIPs 描述了集成问题和解决方案，并提供了通用词汇，但这些词汇并未形式化。Camel 试图通过提供一种描述集成解决方案的语言来弥补这一差距。《企业集成模式》中描述的模式与 Camel 的领域特定语言（DSL）几乎是一一对应的。


**领域特定语言**

在 Camel 诞生之初，其领域特定语言（DSL）是对集成领域的一大贡献。此后，其他几个集成框架也纷纷效仿，推出了基于 Java、XML 或自定义语言的 DSL。DSL 的目的是让开发者专注于集成问题，而不是工具——即编程语言本身。以下是一些使用不同格式但功能等价的 DSL 示例：

- Java DSL
```java
from("file:data/inbox").to("jms:queue:order");
```
- XML DSL
```xml
<route>
  <from uri="file:data/inbox"/>
  <to uri="jms:queue:order"/>
</route>

```
这些示例是真实的代码，它们展示了如何轻松地将文件从一个文件夹路由到 Java 消息服务（JMS）队列。由于底层是一个真正的编程语言，你可以使用现有的工具支持，例如代码补全和编译器错误检测，如图1.3所示。

![Camel Java DSL](/assets/camel/c01_03.png)

在这里，你可以看到 Eclipse IDE 的自动补全功能如何提供一个可用的 DSL 术语列表。

**与负载无关的路由器**

Camel 可以路由任何类型的负载，你不受限于传输标准化的格式，如 XML 负载。这种自由意味着你无需将负载转换为标准格式来简化路由。

**模块化和可插拔架构**

Camel 拥有模块化架构，允许将任何组件加载到 Camel 中，无论该组件是 Camel 自带的、第三方的，还是你自己创建的自定义组件。你还可以配置 Camel 中的几乎所有内容。许多功能都是可插拔和可配置的——从 ID 生成、线程管理、关闭序列器到流缓存等等。

**POJO模型**

Java Bean（或普通 Java 对象，POJO）在 Camel 中被视为一等公民，Camel 致力于让你在集成项目中随时随地使用 Bean。在许多地方，你都可以用自己的自定义代码扩展 Camel 的内置功能。第 4 章将详细讨论在 Camel 中使用 Bean。

**简单易配置**

Camel 尽可能遵循“约定优于配置”的范式，以最小化配置需求。为了在路由中直接配置端点，Camel 使用了一种简单且直观的 URI 配置方式。

例如，你可以配置一个 Camel 路由，从一个文件端点开始，递归扫描子文件夹并仅包含 .txt 文件，如下所示：

```java
from("file:data/inbox?recursive=true&include=.*txt$")...
```
**自动类型转换器**

Camel 内置了一个类型转换机制，提供了超过 350 种转换器。例如，你无需配置类型转换规则即可从字节数组转换为字符串。如果需要转换到 Camel 不支持的类型，你可以创建自己的类型转换器。最棒的是，这一功能在幕后自动工作，你无需为此操心。

Camel 组件也利用了这一特性；它们可以接受大多数类型的数据，并将其转换为它们能够使用的类型。这一功能是 Camel 社区中最受欢迎的功能之一。你甚至可能开始疑惑为什么 Java 本身没有提供这样的功能！第 3 章将更详细地介绍类型转换器。

**轻量级核心，适合微服务**

Camel 的核心可以视为轻量级，总库大小约为 4.9 MB，运行时依赖仅为 1.3 MB。这使得 Camel 易于嵌入或部署到任何地方，例如独立应用程序、微服务、Web 应用程序、Spring 应用程序、Java EE 应用程序、OSGi、Spring Boot、WildFly 以及云平台（如 AWS、Kubernetes 和 Cloud Foundry）。Camel 的设计初衷不是作为服务器或 ESB，而是嵌入到你选择的任何运行时环境中。你只需要 Java。

**云就绪**

除了 Camel 本身支持云原生（在第 18 章中介绍），Camel 还提供了许多与 SaaS 提供商连接的组件。例如，通过 Camel 你可以连接到以下服务：
- Amazon DynamoDB、EC2、Kinesis、SimpleDB、SES、SNS、SQS、SWF 和 S3

- Braintree（PayPal、Apple Pay、Android Pay 等）

- Dropbox

- Facebook

- GitHub

- Google Big Query、Calendar、Drive、Mail 和 Pub Sub

- HipChat

- LinkedIn

- Salesforce

- Twitter

- ……

**测试套件**

Camel 提供了一个测试套件，方便你测试自己的 Camel 应用程序。Camel 自身也广泛使用这个测试套件，包含超过 18,000 个单元测试。测试套件包含特定于测试的组件，例如可以帮助你模拟真实端点。它还允许你设置预期，Camel 可以根据这些预期判断应用程序是否满足要求或失败。第 9 章将介绍 Camel 的测试内容。

**活跃的社区**

Camel 拥有一个活跃的社区，而且这个社区历史悠久。截至撰写本书时，它已经活跃（并不断增长）超过 10 年。对于任何希望在应用程序中使用开源项目的用户来说，拥有强大的社区支持至关重要。不活跃的项目社区支持有限，如果你遇到问题，只能靠自己解决。而使用 Camel 时，如果遇到任何困难，用户和开发者都会提供帮助。有关 Camel 社区的更多信息，请参阅附录 B。

现在你已经了解了构成 Camel 的主要功能，接下来我们将通过查看 Camel 发行版并尝试一个示例来进行更多实践操作。


# 快速开始
本节将向你展示如何获取 Camel 发行版并解释其内容。然后，你将使用 Apache Maven 运行一个示例。完成这些后，你将知道如何运行本书源代码中的任何示例。

首先，我们来获取 Camel 发行版。

## 获取Camel

Camel 可从 Apache Camel 官方网站[http://camel.apache.org/download.html](http://camel.apache.org/download.html) 下载。在此页面上，你会看到所有 Camel 版本的列表以及最新版本的下载链接。

为了本书的目的，我们将使用 Camel 2.20.1。要获取此版本，请点击 Camel 2.20.1 Release 链接。在页面底部附近，你会找到两种二进制发行版：zip 发行版适用于 Windows 用户，tar.gz 发行版适用于 macOS/Linux 用户。下载其中一个发行版后，将其解压到你硬盘上的某个位置。

打开命令提示符，进入你解压 Camel 发行版的位置。在这里执行目录列表命令，你会看到类似以下内容：

```shell
[janstey@ghost apache-camel-2.20.1]$ ls
doc  examples  lib  LICENSE.txt  NOTICE.txt  README.txt
```
正如你所见，发行版体积很小，你可能已经能猜到每个目录包含的内容。以下是详细信息：
- **doc**：包含 HTML 格式的 Camel 手册。该手册是发行时 Apache Camel 网站大部分内容的下载版本。因此，对于无法访问 Camel 网站的用户（或者如果你弄丢了《Camel in Action》这本书），这是一个不错的参考资料。

- **examples**：包含 97 个 Camel 示例。

- **lib**：包含所有 Camel 库。本章稍后将介绍如何使用 Maven 轻松下载核心之外的组件依赖。

- **LICENSE.txt**：包含 Camel 发行版的许可证信息。因为这是一个 Apache 项目，许可证采用 Apache 许可证 2.0 版。

- **NOTICE.txt**：包含 Camel 发行版中包含的第三方依赖的版权信息。

- **README.txt**：包含 Camel 的简短介绍以及帮助新用户快速上手的链接列表。

现在，让我们来尝试本书中的第一个 Camel 示例。

## 第一个Camel体验

到目前为止，我们已经向你展示了如何获取 Camel 发行版并初步了解了其内容。此时，你可以自由探索发行版；所有示例都附有说明，帮助你理解它们。

不过，从现在开始，我们将完全不使用发行版。本书源代码中的所有示例都使用 Apache Maven，这意味着 Camel 库会自动为你下载——无需确保 Camel 发行版的库在类路径上。

你可以通过托管源代码的 GitHub 项目[https://github.com/camelinaction/camelinaction2]（https://github.com/camelinaction/camelinaction2）获取本书的源代码。

你将查看的第一个示例可以视为集成的“hello world”：文件路由。假设你需要从一个目录（data/inbox）读取文件，以某种方式处理它们，然后将结果写入另一个目录（data/outbox）。为了简单起见，你将跳过处理步骤，因此输出仅仅是原始文件的副本。图 1.4 展示了这一过程。

![FileCopier Demo](/assets/camel/c01_04.png)

看起来很简单，对吧？下面是一个使用纯 Java（不使用 Camel）的可能解决方案。

```java
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class FileCopier {

    public static void main(String args[]) throws Exception {
        File inboxDirectory = new File("data/inbox");
        File outboxDirectory = new File("data/outbox");
        outboxDirectory.mkdir();
        File[] files = inboxDirectory.listFiles();
        for (File source : files) {
            if (source.isFile()) {
               File dest = new File(
                    outboxDirectory.getPath()
                    + File.separator
                    + source.getName());
               copyFile(source, dest);
            }
        }
    }
 
    private static void copyFile(File source, File dest)
        throws IOException {
        OutputStream out = new FileOutputStream(dest);
        byte[] buffer = new byte[(int) source.length()];
        FileInputStream in = new FileInputStream(source);
        in.read(buffer);
        try {
            out.write(buffer);
        } finally {
            out.close();
            in.close();
        }
    }
}

```
这个 FileCopier 示例是一个简单的用例，但仍然需要 37 行代码。你必须使用低级的文件 API，并确保资源被正确关闭——这是一项很容易出错的任务。此外，如果你要轮询 data/inbox 目录以查找新文件，你需要设置一个定时器，并跟踪哪些文件已经复制过。这个简单的示例正变得越来越复杂。

像这样的集成任务已经被完成过成千上万次；你不应该每次都需要手动编写这样的代码。我们无需重新发明轮子。让我们看看如果使用 Apache Camel 这样的集成框架，轮询解决方案会是什么样子。

```java
import org.apache.camel.CamelContext;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.impl.DefaultCamelContext;

public class FileCopierWithCamel {

    public static void main(String args[]) throws Exception {
        CamelContext context = new DefaultCamelContext();
        context.addRoutes(new RouteBuilder() {
            public void configure() {
                from("file:data/inbox?noop=true")     #1
.to("file:data/outbox");                       
            }
        });
        context.start();                         
        Thread.sleep(10000);
        context.stop();
    }
}

#1 Routes files from inbox to outbox

```
这段代码的大部分是使用 Camel 时的样板代码。每个 Camel 应用程序都会使用一个 CamelContext，随后启动并停止。你还添加了一个 sleep 方法，以便让这个简单的 Camel 应用程序有时间复制文件。你应该关注的是清单 1.2 中的路由 ❶。

Camel 中的路由定义方式使其在阅读时流畅易懂。这个路由可以这样理解：从文件位置 data/inbox 消费消息，设置 noop 选项，然后发送到文件位置 data/outbox。noop 选项告诉 Camel 保持源文件不变。如果不使用此选项，文件将被移动。大多数从未见过 Camel 的人都能理解这个路由的作用。你可能还想注意，排除样板代码后，你仅用两行 Java 代码就创建了一个文件轮询路由 ❶。

要运行这个示例，你需要从 Maven 网站 http://maven.apache.org/download.html 下载并安装 Apache Maven。安装并配置好 Maven 后，打开终端，进入本书源代码的 chapter1/file-copy 目录。如果在这里执行目录列表命令，你会看到以下内容：

- **data**：包含 inbox 目录，里面有一个名为 message1.xml 的文件。

- **src**：包含本章中展示的清单的源代码。

- **pom.xml**：包含构建示例所需的信息。这是 Maven 项目对象模型（POM）XML 文件。


>**注意：**
>
>我们在本书开发过程中使用了 Maven 3.5.0。不同版本的 Maven 可能无法完全按照我们展示的方式工作或显示。

POM文件如下所示：

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <parent>
    <groupId>com.camelinaction</groupId>     #1
    <artifactId>chapter1</artifactId>          
    <version>2.0.0</version>                   
  </parent>

  <artifactId>chapter1-file-copy</artifactId>
  <name>Camel in Action 2 :: Chapter 1 :: File Copy Example</name>

  <dependencies>
    <dependency>
      <groupId>org.apache.camel</groupId>     #2
      <artifactId>camel-core</artifactId>     #2
    </dependency>
    <dependency>
      <groupId>org.slf4j</groupId>     #3
      <artifactId>slf4j-log4j12</artifactId>     #3 
    </dependency>                              
  </dependencies>
</project>

#1 Parent POM
#2 Camel’s core library
#3 Logging support

```
Maven 本身是一个复杂的主题，我们在此不做深入探讨。我们将提供足够的信息，让你能够高效地运行本书中的示例。第 8 章还将介绍使用 Maven 开发 Camel 应用程序，因此那里也有大量相关信息。

清单 1.3 中的 Maven POM 可能是你见过的最短的 POM 之一——几乎所有内容都使用了 Maven 提供的默认设置。除了这些默认设置外，父 POM ❶ 中还配置了一些设置。这里最需要指出的可能是对 Camel 库的依赖 ❷。这个依赖元素告诉 Maven 执行以下操作：

- 根据 groupId、artifactId 和 version 创建搜索路径。version 元素设置为 camel-version 属性，该属性在父元素 ❶ 引用的 POM 中定义，解析为 2.20.1。未指定依赖类型，因此假定为 JAR 文件类型。搜索路径为 org/apache/camel/camel-core/2.20.1/camel-core-2.20.1.jar。

- 由于清单 1.3 未定义 Maven 查找 Camel 依赖的特殊位置，Maven 将在 Maven 中央仓库（位于 http://repo1.maven.org/maven2）中查找。

- 结合搜索路径和仓库 URL，Maven 尝试下载 http://repo1.maven.org/maven2/org/apache/camel/camel-core/2.20.1/camel-core-2.20.1.jar。

- 此 JAR 文件将被保存到 Maven 的本地下载缓存中，通常位于家目录下的 .m2/repository。在 Linux/macOS 上为 ~/.m2/repository，在最新版本的 Windows 上为 C:\Users<用户名>.m2\repository。

- 当启动清单 1.2 中的应用程序代码时，Camel JAR 将被添加到类路径中。

要运行清单 1.2 中的示例，进入 chapter1/file-copy 目录并使用以下命令：

```shell
mvn compile exec:java
```

这条命令指示 Maven 编译 src 目录中的源代码，并执行 FileCopierWithCamel 类，同时将 camel-core JAR 添加到类路径中。

> **注意**:
> 
> 要运行本书中的任何示例，你需要连接到互联网。Apache Maven 将下载示例所需的许多 JAR 依赖。整个示例集合将下载数百兆字节的库文件。
 
从 chapter1/file-copy 目录运行 Maven 命令，完成后，浏览到 data/outbox 文件夹，你将看到刚刚复制的文件。恭喜你——你已经运行了第一个 Camel 示例！这是一个简单的示例，但了解它的设置方式将使你能够运行本书中的几乎所有示例。

现在，我们需要介绍 Camel 的基础知识和集成领域的概况，以确保你为使用 Camel 做好充分准备。我们将重点探讨消息模型、架构以及其他一些 Camel 概念。大多数抽象概念基于已知的企业集成模式（EIP），并保留了它们的名称和语义。我们将从 Camel 的消息模型开始。


# Camel的消息模型

## Message

## Exchage

# Camel的架构

## 俯瞰架构

## Camel