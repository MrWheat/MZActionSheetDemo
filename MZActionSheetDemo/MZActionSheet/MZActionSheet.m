//
//  MZActionSheet.m
//  MZActionSheetDemo
//
//  Created by 麦子 on 16/7/27.
//  Copyright © 2016年 麦子. All rights reserved.
//

#import "MZActionSheet.h"

#define CellHeight 45.f  // 按钮的高度

@interface MZActionSheet () <UITableViewDelegate, UITableViewDataSource>

{
    ClickedIndexBlock _clickBlcok;
    UITableView *_tableView;
    NSMutableArray *_otherButtons;  // 其他按钮
    NSString *_titleString;     // title
    NSString *_cancelString;    // 取消title
    UIView *_blackBgV;          // 遮罩视图
    UIButton *_cancelB;         // 取消按钮
    NSInteger _buttonCount;     // 按钮个数
    CGFloat _actionHeight;      // actionView的高度
    CGFloat _tableViewHeight;   // TableView的高度
    UIView *_actionSheetV;      // actionView
}

@end

@implementation MZActionSheet

- (instancetype)initWithTitle:(NSString *)title clickedAtIndex:(ClickedIndexBlock)block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super init]) {
        _titleString = title;
        _clickBlcok = block;
        _cancelString = cancelButtonTitle;
        _otherButtons = [[NSMutableArray alloc]init];
        // 获取可变参数
        [_otherButtons addObject:otherButtonTitles];
        va_list list;
        NSString *curStr;
        va_start(list, otherButtonTitles);
        while ((curStr = va_arg(list, NSString *))) {
            [_otherButtons addObject:curStr];
        }
        // 计算button个数
        if(_titleString && ![@"" isEqualToString:_titleString]) {
            _buttonCount += 1;
        }
        _buttonCount += _otherButtons.count;
        _tableViewHeight = CellHeight * _buttonCount;
        if(_cancelString && ![@"" isEqualToString:_cancelString]) {
            _buttonCount += 1;
        }
        _actionHeight = CellHeight * _buttonCount + 10;
        //初始化子视图
    }
    return self;
}

- (void)installSubViews {
    self.frame = [UIScreen mainScreen].bounds;
    
    // 初始化遮罩视图
    _blackBgV = [[UIView alloc]initWithFrame:self.bounds];
    _blackBgV.backgroundColor = [UIColor colorWithWhite:0.142 alpha:1.000];
    _blackBgV.alpha = 0.4f;
    [self addSubview:_blackBgV];
    
    // 初始化actionSheetView
    _actionSheetV = [[UIView alloc] initWithFrame:CGRectMake(0.0f,self.bounds.size.height, self.bounds.size.width, _actionHeight)];
    [self addSubview:_actionSheetV];
    
    if(_cancelString && ![@"" isEqualToString:_cancelString]) {
        _buttonCount += 1;
    }
    
    // 初始化TableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15.0f,0.0f, self.bounds.size.width-30, _tableViewHeight) style:UITableViewStylePlain];
    _tableView.layer.cornerRadius = 5;
    _tableView.layer.masksToBounds = YES;
    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [_actionSheetV addSubview:_tableView];
    _tableView.backgroundColor = [UIColor clearColor];
    
    if(_cancelString && ![@"" isEqualToString:_cancelString]) {
        _cancelB = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.cancelButtonFont) {
            [_cancelB.titleLabel setFont:self.cancelButtonFont];
        } else {
            [_cancelB.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        }
        [_cancelB setBackgroundColor:[UIColor whiteColor]];
        [_cancelB setTitle:_cancelString forState:UIControlStateNormal];
        if (self.cancelButtonColor) {
            [_cancelB setTitleColor:self.cancelButtonColor forState:UIControlStateNormal];
        } else {
            [_cancelB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        _cancelB.layer.cornerRadius = 5;
        [_cancelB setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelB setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1]] forState:UIControlStateHighlighted];
        [_cancelB addTarget:self action:@selector(cancelButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        _cancelB.layer.masksToBounds = YES;
        _cancelB.frame = CGRectMake(15, _tableView.frame.size.height+5, _tableView.frame.size.width, CellHeight);
        [_actionSheetV addSubview:_cancelB];
    }
    
    // 遮罩加上手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    [_blackBgV addGestureRecognizer:tap];
    self.hidden = YES;
    _actionSheetV.hidden = YES;
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)show
{
    [self installSubViews];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _actionSheetV.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height - _actionHeight;
        _actionSheetV.frame = frame;
        _actionSheetV.hidden = NO;
    } completion:^(BOOL finished) {
    }];
}

- (void)cancelButtonDown:(UIButton *)sender {
    if(_clickBlcok) {
        _clickBlcok(_otherButtons.count);
    }
    [self tapClick:nil];
}

- (void)tapClick:(UIGestureRecognizer *)tap {
    __block typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = _actionSheetV.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height + _actionHeight;
        _actionSheetV.frame = frame;
    } completion:^(BOOL finished) {
        weakSelf.hidden = YES;
        _actionSheetV.hidden = YES;
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0 && _titleString) {
        return CellHeight;
    }
    return 0.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 && _titleString) {
        UIView *headView = [[UIView alloc] init];
        
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor whiteColor];
        if (self.titleFont) {
            [label setFont:self.titleFont];
        } else {
            [label setFont:[UIFont systemFontOfSize:13.0f]];
        }
        label.numberOfLines = 0;
        [label setText:_titleString];
        [label setTextAlignment:NSTextAlignmentCenter];
        if (self.titleColor) {
            [label setTextColor:self.titleColor];
        } else {
            [label setTextColor:[UIColor colorWithRed:0xc5/255.0 green:0xc5/255.0 blue:0xc5/255.0 alpha:1]];
        }
        label.frame = CGRectMake(0, 0, _tableView.bounds.size.width, CellHeight);
        [label setAdjustsFontSizeToFitWidth:YES];
        [headView addSubview:label];
        
        UILabel *sepLine = [[UILabel alloc] init];
        sepLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
        sepLine.frame = CGRectMake(0, CellHeight - 1.f, _tableView.bounds.size.width, 1.f);
        [headView addSubview:sepLine];
        
        return headView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // Block方式返回结果
    if(_clickBlcok) {
        _clickBlcok(indexPath.row);
    }
    [self tapClick:nil];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"actionsheetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:identify];
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.masksToBounds = YES;
        // 加上分割线
        UILabel *sepLine = [[UILabel alloc] init];
        sepLine.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:241/255.0 alpha:1];
        sepLine.frame = CGRectMake(0, CellHeight - 1.f, [UIScreen mainScreen].bounds.size.width, 1.f);
        [cell addSubview:sepLine];
    }
    if (self.otherButtonFont) {
        [cell.textLabel setFont:self.otherButtonFont];
    } else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0f]];
    }
    if (self.otherButtonColor) {
        [cell.textLabel setTextColor:self.otherButtonColor];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    if(indexPath.section == 0){
        [cell.textLabel setText:_otherButtons[indexPath.row]];
    }
    if(indexPath.section == 1){
        [cell.textLabel setText:_cancelString];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return _otherButtons.count;
    }
    return 0;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
