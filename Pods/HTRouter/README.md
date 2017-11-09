# 初始化DXRouter

在`application:didFinishLaunchingWithOptions:`中配置初始ViewController
```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [DXRouter startupWithHomeViewController:@"DXHome"];
    return YES;
}
```
`DXHome`表示`DXHomeViewController`，系统会先查看`DXHome`有没有对应的Class，如果有并且confirm了协议`DXRouterViewControllerInstantiation`，则使用它进行初始化。如果没有找到对应的Class，则加上后缀ViewController再次尝试。

> DXHome 这种ViewController的标识我们在下文统一称之为`viewControllerName`。

# 如何标识ViewController

当我们使用`DXHome`这种标识来表示ViewController时，在对应的ViewController中要做以下几件事情。

实现协议`DXRouterViewControllerInstantiation`
```
@interface DXHomeViewController () <DXRouterViewControllerInstantiation>
```
协议中只有一个必须实现的方法 `+ (instancetype)instantiateViewController;`,返回ViewController的实例。这里提供了两个宏来方便完成这个任务。

1. `DXRouterInitPageFromStoryboard(@"Main", @"DXHomeViewController")`,这个是从Storyboard中初始化你的ViewController，Main是Storyboard文件名，DXHomeViewController是对应的ViewController的StoryboardID。
1. `DXRouterInitPage()`，这个初始化通过代码编写的ViewController,直接调用`[ViewController new]`初始化。


# 基本跳转

`- (void)navigateTo:(NSString *)viewControllerName arguments:(NSDictionary *)arguments allowRepeat:(BOOL)allowRepeat`
跳转到标识为`viewControllerName`的ViewController。`arguments`携带的参数会寻找与key值字符串一致的ViewController的属性进行赋值。allowRepeat表示如果当前
的topViewController和要跳转到的ViewController是同一个时，是否重复跳转。

`- (void)navigateTo:(NSString *)viewControllerName arguments:(NSDictionary *)arguments`默认不允许重复，allowRepeat为NO。

# 回退

```
- (void)goBack;
- (void)goBackToRoot;
```
这两个支持了最基本的回退。当我们要回退到指定的ViewController时，可以使用
```
- (BOOL)goBackTo:(NSString *)viewControllerName;
```
返回值表示是否跳转成功，因为你指定的ViewController可能不在Navigation的栈里面。
如果我们跳转时Navigation栈里有多个一样的ViewController,比如root->A->B->A->B->C->B,此时我们想要跳回到第一个A，就可以使用
```
- (BOOL)goBackToFirstOf:(NSString *)viewControllerName;
```
跳回到第一次出现`viewControllerName`的地方。我们还可以使用
```
- (BOOL)goBackToLastOf:(NSString *)viewControllerName;
```
跳回到最后一次出现`viewControllerName`的地方。

# 以Dialog的形式展现ViewController

`- (void)presentAsDialog:(NSString *)viewControllerName arguments:(NSDictionary *)arguments completeBlock:(DXRouterDialogCompleteBlock)completeBlock;`
前两个参数和navigate时一致，completeBlock将会在Dialog消失时回调。

对于支持Dialog显示的ViewController，需要实现`DXRouterViewControllerDialog`协议。
```
@interface DXDialogViewController () <DXRouterViewControllerInstantiation,DXRouterViewControllerDialog>

@end
```
同时使用宏`DXRouterInitDialog(30, 300)`进行Dialog尺寸的配置。
```
DXRouterInitPage()
DXRouterInitDialog(30, 300)
```
DXRouterInitDialog第一个参数为横向左右的padding，比如padding是30，宽就是ScreenWidth - 30 * 2，第二个参数是高。
想要关闭窗口，就调用`completedBlock(result);`,result为向外传递的参数，可为nil;

# 通过指定Navigation的路径来进行导航

假设我当前的页面路径是 A->B->C,我想跳转到D，并且让当前的页面路径变为 A->E->D。可以使用
```
- (void)navigateWithArguments:(NSDictionary *)arguments fullRouter:(NSArray *)router forceJumpToFirstPage:(BOOL)force;
```
router中可以赋值`@[@"A",@"E",@"D"]`,一开始会检测当前的页面是否为router的第一个页面（A）,如果是，则直接跳转E和D。如果不是，forceJumpToFirstPage为NO就停止处理，forceJumpToFirstPage为YES时，则强行跳回A，跳回成功，则继续跳ED，否则什么都不处理。
```
- (void)navigateWithArguments:(NSDictionary *)arguments fullRouter:(NSArray *)router;
```
是forceJumpToFirstPage为YES的简化版。

```
- (void)navigateWithArguments:(NSDictionary *)arguments additionRouter:(NSArray *)router;
```
和fullRouter不同的是不会检测第一个页面是否匹配，直接将router中的所有页面压入Navigation栈。

# 注意

## navigate系列的方法在navigate之前都会先尝试dismiss掉当前的Dialog。
## 多个Dialog同时present时，会进入队列进行排队，前一个消失，下一个才会出现。
