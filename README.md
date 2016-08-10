# MZActionSheetDemo

iOS底部弹出视图，根据需要可以自定义颜色和字体。

预留了一些属性，可自己更改。

掉用以下方法对ActionSheet初始化。

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

初始化完成后，修改控件属性，这里预留了一些可能用到的属性，可以根据需要更改。

```python
@property (nonatomic, strong)UIColor *cancelButtonColor;       // 取消按钮的颜色
@property (nonatomic, strong)UIColor *otherButtonColor;         // 其他按钮的颜色
@property (nonatomic, strong)UIColor *titleColor;               // 标题颜色
@property (nonatomic, strong)UIFont *cancelButtonFont;          // 取消按钮的字体
@property (nonatomic, strong)UIFont *otherButtonFont;           // 其他按钮的字体
@property (nonatomic, strong)UIFont *titleFont;                 // 标题的字体
```

最后调用以下方法显示。

    /**
     *  ActionSheet显示
     */
    - (void)show;



