//
//  SYPcGraphView.m
//  ondine
//
//  Created by 杨淳引 on 15/6/1.
//  Copyright (c) 2015年 杨淳引. All rights reserved.
//

#import "SYPcGraphView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kGraphBtnX 50
#define kGraphBtnHeight 40

@interface SYPcGraphView()
/**
 *   用来记录查询的这段时间的总时长
 */
@property (nonatomic, assign) NSInteger allDuration;
@end

@implementation SYPcGraphView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self detailsOfInitWithFrame];
    }
    return self;
}


/**
 *   把initWithFrame:方法的具体加载内容整合在这个方法里
 */
-(void)detailsOfInitWithFrame{
    self.backgroundColor = [UIColor whiteColor];
    
    CGSize tempSize;
    tempSize.width = kScreenWidth;
    self.contentSize = tempSize;
}


/**
 *   这个方法会把休息事件也建立好模型对象，然后加到数组里
 */
-(NSArray *)tackleRectGraphesWithStartTimeStamp:(NSInteger)startTimeStamp endTimeStamp:(NSInteger)endTimeStamp{
    //1、先取出数据库里所有事件
    NSMutableArray *arrayM = [NSMutableArray array];
    arrayM = [SYPcRectGraphTool pcRectGraphesWithStartTimeStamp:startTimeStamp andEndTimeStamp:endTimeStamp];
    
    //2、根据数据库里所有事件的duration和根据参数时间得出的总duration，计算出休息事件的duration
    NSInteger allEventsDuration = 0;
    for(int n = 0; n < arrayM.count; n++){
        SYPcRectGraph *graph = arrayM[n];
        allEventsDuration += graph.duration;
    }
    NSInteger aDuration = endTimeStamp - startTimeStamp;
    self.allDuration = aDuration;
    NSInteger restDuration = self.allDuration - allEventsDuration;
    
    //3、新建休息事件的SYPcRectGraph模型对象
    SYPcRectGraph *graph = [[SYPcRectGraph alloc]init];
    graph.duration = restDuration;
    graph.graphName = @"休息";
    graph.graphColorR = 255;
    graph.graphColorG = 255;
    graph.graphColorB = 255;
    
    //4、把休息事件也添加到数组里
    [arrayM addObject:graph];
    
    //5、排序
    [arrayM sortUsingComparator:^NSComparisonResult(SYPcRectGraph *obj1, SYPcRectGraph *obj2) {
        return obj1.duration < obj2.duration;
    }];
    
    //6、赋值，返回
    return arrayM;
}

/**
 *   画柱形图的方法，根据传进来的两个时间戳去查找数据，画图
 */
-(void)drawGraphWithStartTimeStamp:(NSInteger)startTimeStamp endTimeStamp:(NSInteger)endTimeStamp{
    //1、如果之前已有查询，先把之前显示的图形去除掉
    for(UIButton *lastBtn in self.subviews){
        [lastBtn removeFromSuperview];
    }
    for(UILabel *lastLabel in self.subviews){
        [lastLabel removeFromSuperview];
    }
    
    //2、拿到所有事件，包括休息事件
    NSArray *graphes = [self tackleRectGraphesWithStartTimeStamp:startTimeStamp endTimeStamp:endTimeStamp];
    NSInteger graphCount = graphes.count;
    
    //3、重新设置scrollView的contentSize
    CGSize tempSize;
    tempSize.height = (50 * graphCount) + 30;
    self.contentSize = tempSize;
    self.backgroundColor = [UIColor whiteColor];
    
    //4、一个事件一个事件显示到self上
    for(int n = 0; n < graphCount; n++){
        //(1)、取出要画的图形的实例
        SYPcRectGraph *graph = graphes[n];

        //(2)、画图形(图形其实是一个UIButton)
        NSInteger kGraphBtnY = 50 * n + 10;
        NSInteger kGraphBtnWidth = (kScreenWidth - (kGraphBtnX * 2)) * graph.duration / self.allDuration;
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kGraphBtnX, kGraphBtnY, kGraphBtnWidth, kGraphBtnHeight)];
        btn.backgroundColor = RGB(graph.graphColorR, graph.graphColorG, graph.graphColorB);
            //由于休息事件是白色的，和bgColor相同，所以要加上黑框来区别对待
        if([graph.graphName isEqualToString:@"休息"]){
            [btn.layer setBorderWidth:1.0];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 0, 1 });
            [btn.layer setBorderColor:colorref];
        }
            //设置图形按钮的title，然后让它颜色和按钮背景色相同，有了title就可以把duration传给监听方法
        [btn setTitle:[NSString stringWithFormat:@"%ld", (long)graph.duration] forState:UIControlStateNormal];
        [btn setTitleColor:RGB(graph.graphColorR, graph.graphColorG, graph.graphColorB) forState:UIControlStateNormal];
            //添加点击图表形按钮弹出下拉框的监听方法
        [btn addTarget:self action:@selector(showDropDownManu:) forControlEvents:UIControlEventTouchUpInside];
        
        //(3)、设置事件的名称，让它显示在图形左侧
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.width = kGraphBtnX;
        nameLabel.height = kGraphBtnHeight * 0.5;
        nameLabel.y = kGraphBtnY + kGraphBtnHeight * 0.25;
        nameLabel.x = 0;
        nameLabel.text = graph.graphName;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:12.0];
        
        //(4)、设置事件的时间百分比，让它显示在图形右侧
        UILabel *percentageLabel = [[UILabel alloc]init];
        percentageLabel.width = kGraphBtnX;
        percentageLabel.height = kGraphBtnHeight * 0.5;
        percentageLabel.y = kGraphBtnY + kGraphBtnHeight * 0.25;
        percentageLabel.x = kGraphBtnX + kGraphBtnWidth;
        NSString *percentage = [NSString stringWithFormat:@"%%%.2f", (graph.duration * 100.00 / self.allDuration)];
        percentageLabel.text = percentage;
        percentageLabel.textAlignment = NSTextAlignmentCenter;
        percentageLabel.font = [UIFont systemFontOfSize:12.0];
        
        //(5)、添加控件到页面上
        [self addSubview:btn];
        [self addSubview:nameLabel];
        [self addSubview:percentageLabel];
    }

}

/**
 *   点击图形按钮的触发方法，会显示一个下拉框
 */
-(void)showDropDownManu:(UIButton *)btn{
    //1、添加蒙板SYDropDownMenuBackground
    SYDropDownMenuBackground *menu = [SYDropDownMenuBackground menu];
    
    //2、新建下拉框SYDropDownMenuController的实例，然后指定给蒙板
    SYDropDownMenuController *menuController = [[SYDropDownMenuController alloc]init];
    [menuController setDetail:btn];
    menuController.view.height = 50; //宽高固定的
    menuController.view.width = 80;
    menu.contentController = menuController;
    
    //3、显示蒙板
    [menu showFrom:btn];
}
@end









