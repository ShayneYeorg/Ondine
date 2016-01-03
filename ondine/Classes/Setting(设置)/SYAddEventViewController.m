//
//  SYAddEventViewController.m
//  ondine
//
//  Created by 杨淳引 on 15/5/27.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYAddEventViewController.h"

// RGB颜色
#define SYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kUIWidth ([UIScreen mainScreen].bounds.size.width - 20)
#define kNameFieldY CGRectGetMaxY(self.nameLable.frame)
#define kColorLabelY CGRectGetMaxY(self.nameField.frame)
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenCenterX ([UIScreen mainScreen].bounds.size.width * 0.5)
#define kColViewY CGRectGetMaxY(self.colorLable.frame)
#define kColViewWidth [UIScreen mainScreen].bounds.size.width
#define kColViewHeight (kScreenHeight - self.commitButton.height - kColViewY - 30)

@interface SYAddEventViewController()
/**
 *   用来显示所有可选颜色的collectionView
 */
@property (nonatomic, strong) UICollectionView *colView;

/**
 *   存放所有颜色组成的数组
 */
@property (nonatomic, strong) NSArray *colorArray;

/**
 *   添加事件过程中选中的颜色
 */
@property (nonatomic, copy) NSString *selectedColor;

/**
 *   添加的事件名称的提示文字
 */
@property (nonatomic, strong) UILabel *nameLable;

/**
 *   填写添加的事件的名称的textField
 */
@property (nonatomic, strong) UITextField *nameField;

/**
 *   选择事件颜色的提示文字
 */
@property (nonatomic, strong) UILabel *colorLable;

/**
 *   提交按钮
 */
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation SYAddEventViewController
-(UIButton *)commitButton{
    if(_commitButton == nil){
        //初始化按钮
        UIButton *commitBtn = [[UIButton alloc]init];
        [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        //设置图片
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"commitButton"] forState:UIControlStateNormal];
        [commitBtn setBackgroundImage:[UIImage imageNamed:@"commitButton_selected"] forState:UIControlStateHighlighted];
        //设置尺寸
        commitBtn.width = 250;
        commitBtn.height = 50;
        commitBtn.centerX = kScreenCenterX;
        commitBtn.y = kScreenHeight - commitBtn.height - 10;
        
        _commitButton = commitBtn;
        [self.view addSubview:_commitButton];
    }
    return _commitButton;
}

-(UILabel *)nameLable{
    if(_nameLable == nil){
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, kUIWidth, 40)];
        lable.text = @"请输入事件名称";
        lable.textColor = SYColor(0, 150, 30);
        lable.textAlignment = NSTextAlignmentCenter;
        _nameLable = lable;
        [self.view addSubview:_nameLable];
    }
    return _nameLable;
}

-(UITextField *)nameField{
    if(_nameField == nil){
        UITextField *field = [[UITextField alloc]initWithFrame:CGRectMake(10, kNameFieldY, kUIWidth, 40)];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.enabled = YES;
        field.userInteractionEnabled = YES;
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameField = field;
        _nameField.delegate = self;
        [self.view addSubview:_nameField];
    }
    return _nameField;
}

-(UILabel *)colorLable{
    if(_colorLable == nil){
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10, kColorLabelY, kUIWidth, 40)];
        lable.text = @"请选择事件代表色";
        lable.textColor = SYColor(0, 150, 30);
        lable.textAlignment = NSTextAlignmentCenter;
        _colorLable = lable;
        [self.view addSubview:_colorLable];
    }
    return _colorLable;
}

-(NSArray *)colorArray{
    if(_colorArray == nil){
        _colorArray = @[@"event_red", @"event_red2", @"event_red3", @"event_red4", @"event_pink", @"event_pink2", @"event_purple", @"event_purple2", @"event_purple3", @"event_blue", @"event_blue2", @"event_blue3", @"event_wathet", @"event_wathet2", @"event_wathet3", @"event_reseda", @"event_reseda2", @"event_reseda3", @"event_green", @"event_green2", @"event_green3", @"event_green4", @"event_yellow", @"event_yellow2", @"event_yellow3", @"event_yellow4", @"event_brown", @"event_brown2", @"event_brown3", @"event_orange", @"event_orange2", @"event_orange3", @"event_gray", @"event_gray2", @"event_gray3"];
    }
    return _colorArray;
}

-(UICollectionView *)colView{
    if (_colView == nil) {
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    _colView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, kColViewY, kColViewWidth, kColViewHeight) collectionViewLayout:flowLayout];
    _colView.dataSource=self;
    _colView.delegate=self;
    [_colView setBackgroundColor:[UIColor clearColor]];
    _colView.allowsMultipleSelection = NO;
        
    //注册Cell，这个必须要有
    [_colView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EventColorCell"];
        
    [self.view addSubview:_colView];
    }
    return _colView;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self detailsOfViewDidLoad];
}

/**
 *   把viewDidLoad里的加载语句整合在这个方法里
 */
-(void)detailsOfViewDidLoad{
    [self colView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"back_icon" highImage:@"back_icon"];
}

/**
 *   导航栏上的返回按钮的触发方法，会发送通知
 */
- (void)back{
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"reload", @"reload", nil];
    NSNotification *notification = [NSNotification notificationWithName:@"reload" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *   确定按钮的触发方法，会在这个方法里判断提交的内容是否合法
 */
-(void)commit{
    //1、必须有填事件名称
    if(self.nameField.text.length > 0){
        SYEvent *event = [[SYEvent alloc]init];
        event.eventName = self.nameField.text;
        
        //2、必须有选择事件代表色
        if(self.selectedColor.length > 0){
            event.eventColor = self.selectedColor;
            
            //3、事件名称不能和已有名称重复
            if([SYEventTool isExist:event]){
                [[[UIAlertView alloc]initWithTitle:@"添加失败" message:@"事件已存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
            }else{
                
                //4、都没问题了就可以添加进数据库
                [SYEventTool addEvent:event];
                [[[UIAlertView alloc]initWithTitle:@"添加成功" message:@"事件已添加" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show];
            }
        }else{
            [[[UIAlertView alloc]initWithTitle:@"代表色不能为空" message:@"请选择代表色" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        }
    }else{
        [[[UIAlertView alloc]initWithTitle:@"事件不能为空" message:@"请输入事件名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.colorArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //1、建立cell
    static NSString * CellIdentifier = @"EventColorCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //2、设置cell的显示图片
    UIView *backgroundView = [[UIView alloc]init];
    UIImageView *backgroundViewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.colorArray[indexPath.row]]];
    backgroundViewImage.size = CGSizeMake(50, 50);
    [backgroundView addSubview:backgroundViewImage];
    cell.backgroundView = backgroundView;
    
    //3、如果哪个cell有打勾的标识，把钩去掉
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //1、注销掉nameField的第一响应
    [self.nameField resignFirstResponder];
    
    //2、拿到选中的那个cell，给它增加一个打勾符号的子视图
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIView *selectedView = [[UIView alloc]init];
    UIImageView *selectedLogo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"event_selected"]];
    selectedLogo.size = CGSizeMake(50, 50);
    UIImageView *selectedViewImage = selectedLogo;
    [selectedView addSubview:selectedViewImage];
    cell.selectedBackgroundView = selectedView;
    
    //3、把选中的颜色保存到self.selectedColor中
    self.selectedColor = self.colorArray[indexPath.row];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark - UITextFieldDelegate
//选中其他控件的时候self.nameField注销第一响应
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameField resignFirstResponder];
    return YES;
}

//点击页面空白位置的时候self.nameField注销第一响应
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.nameField resignFirstResponder];
}

#pragma mark - UIAlertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([alertView.title isEqualToString: @"添加成功"]){
        [self back];
    }else if([alertView.title isEqualToString: @"代表色不能为空"]){
        [self.nameField becomeFirstResponder];
    }else{
        self.nameField.text = @"";
        [self.nameField becomeFirstResponder];
    }
    return;
}
@end
