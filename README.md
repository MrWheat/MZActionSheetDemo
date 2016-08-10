# MZActionSheetDemo

iOS底部弹框视图，根据需要可以自定义颜色和字体。

以下是效果图：

![](https://github.com/MrWheat/MZActionSheetDemo/blob/master/MZActionSheetDemoImage.gif?raw=true)

使用步骤如下：

首先调用以下方法对ActionSheet初始化。

```Objective-c
/**
 *  ActionSheet初始化
 *
 *  @param title             标题
 *  @param block             点击事件回调
 *  @param cancelButtonTitle 取消按钮标题
 *  @param otherButtonTitles 其他按钮标题
 *
 *  @return self
 */
- (instancetype)initWithTitle:(NSString *)title
               clickedAtIndex:(ClickedIndexBlock)block
            cancelButtonTitle:(NSString *)cancelButtonTitle
            otherButtonTitles:(NSString *)otherButtonTitles, ...;
```

初始化完成后，修改控件属性，这里预留了一些可能用到的属性，可以根据需要更改。

```Objective-c
@property (nonatomic, strong)UIColor *cancelButtonColor;       // 取消按钮的颜色
@property (nonatomic, strong)UIColor *otherButtonColor;         // 其他按钮的颜色
@property (nonatomic, strong)UIColor *titleColor;               // 标题颜色
@property (nonatomic, strong)UIFont *cancelButtonFont;          // 取消按钮的字体
@property (nonatomic, strong)UIFont *otherButtonFont;           // 其他按钮的字体
@property (nonatomic, strong)UIFont *titleFont;                 // 标题的字体
```

最后调用以下方法将弹框显示到屏幕上。

```Objective-c
/**
 *  ActionSheet显示
 */
- (void)show;
```

例：

```Objective-c
MZActionSheet *sheet = [[MZActionSheet alloc] initWithTitle:@"这是标题" clickedAtIndex:^(NSInteger index) {
    switch (index) {
        case 0:
        {
            NSLog(@"第一个按钮点击");
        }
            break;
        case 1:
        {
            NSLog(@"第二个按钮点击");
        }
            break;
        case 2:
        {
            NSLog(@"取消按钮点击");
        }
            break;
        default:
            break;
    }
} cancelButtonTitle:@"取消" otherButtonTitles:@"按钮1", @"按钮2", nil];
sheet.titleFont = [UIFont systemFontOfSize:18];
sheet.titleColor = [UIColor blackColor];
[sheet show];
```
