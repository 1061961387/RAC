//
//  ThirdViewController.m
//  ReactiveCocoaDemo
//
//  Created by 楠王 on 2017/11/18.
//  Copyright © 2017年 裕福. All rights reserved.
//

#import "ThirdViewController.h"
#import <RMActionController/RMActionController.h>
#import <RMPickerViewController/RMPickerViewController.h>
#import <RMDateSelectionViewController/RMDateSelectionViewController.h>

@interface ThirdViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation ThirdViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"aa",@"bb",@"cc",@"dd",@"ee", nil];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor yellowColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self creatDatePicker];
}

- (void)creatPickerView{
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<UIPickerView *> *selectAction = [RMAction<UIPickerView *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSMutableArray *selectedRows = [NSMutableArray array];
        NSLog(@"ffff -- %ld",(long)[controller.contentView numberOfComponents]);
        
        for(NSInteger i=0 ; i<[controller.contentView numberOfComponents] ; i++) {
            [selectedRows addObject:@([controller.contentView selectedRowInComponent:i])];
        }
        
        NSLog(@"Successfully selected rows: %@", selectedRows);
    }];
    
    RMAction<UIPickerView *> *cancelAction = [RMAction<UIPickerView *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIPickerView *> *controller) {
        NSLog(@"Row selection was canceled");
    }];
    
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:style];
    pickerController.title = @"Test";
    pickerController.message = @"This is a test message.\nPlease choose a row and press 'Select' or 'Cancel'.";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    
    //You can enable or disable blur, bouncing and motion effects
    pickerController.disableBouncingEffects = NO;
    pickerController.disableMotionEffects = NO;
    pickerController.disableBlurEffects = NO;
    
    //On the iPad we want to show the picker view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
//    if([pickerController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        //First we set the modal presentation style to the popover style
//        pickerController.modalPresentationStyle = UIModalPresentationPopover;
//
//        //Then we tell the popover presentation controller, where the popover should appear
//        pickerController.popoverPresentationController.sourceView = self.tableView;
//        pickerController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    }
    
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)creatDatePicker
{
    RMActionControllerStyle style = RMActionControllerStyleWhite;
    
    RMAction<UIDatePicker *> *selectAction = [RMAction<UIDatePicker *> actionWithTitle:@"Select" style:RMActionStyleDone andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Successfully selected date: %@", controller.contentView.date);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:controller.contentView.date];
        NSLog(@"dateString = %@",dateString);
    }];
    
    RMAction<UIDatePicker *> *cancelAction = [RMAction<UIDatePicker *> actionWithTitle:@"Cancel" style:RMActionStyleCancel andHandler:^(RMActionController<UIDatePicker *> *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:style];
    dateSelectionController.title = @"Test";
    dateSelectionController.message = @"This is a test message.\nPlease choose a date and press 'Select' or 'Cancel'.";
    
    [dateSelectionController addAction:selectAction];
    [dateSelectionController addAction:cancelAction];
    
    RMAction<UIDatePicker *> *in15MinAction = [RMAction<UIDatePicker *> actionWithTitle:@"15 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:15*60];
        NSLog(@"15 Min button tapped");
    }];
    in15MinAction.dismissesActionController = NO;
    
    RMAction<UIDatePicker *> *in30MinAction = [RMAction<UIDatePicker *> actionWithTitle:@"30 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:30*60];
        NSLog(@"30 Min button tapped");
    }];
    in30MinAction.dismissesActionController = NO;
    
    RMAction<UIDatePicker *> *in45MinAction = [RMAction<UIDatePicker *> actionWithTitle:@"45 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:45*60];
        NSLog(@"45 Min button tapped");
    }];
    in45MinAction.dismissesActionController = NO;
    
    RMAction<UIDatePicker *> *in60MinAction = [RMAction<UIDatePicker *> actionWithTitle:@"60 Min" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> *controller) {
        controller.contentView.date = [NSDate dateWithTimeIntervalSinceNow:60*60];
        NSLog(@"60 Min button tapped");
    }];
    in60MinAction.dismissesActionController = NO;
    
    RMGroupedAction<UIDatePicker *> *groupedAction = [RMGroupedAction<UIDatePicker *> actionWithStyle:RMActionStyleAdditional andActions:@[in15MinAction, in30MinAction, in45MinAction, in60MinAction]];
    
//    [dateSelectionController addAction:groupedAction];
    
    RMAction<UIDatePicker *> *nowAction = [RMAction<UIDatePicker *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    
    [dateSelectionController addAction:nowAction];
    
    //You can enable or disable blur, bouncing and motion effects
    dateSelectionController.disableBouncingEffects = NO;
    dateSelectionController.disableMotionEffects = NO;
    dateSelectionController.disableBlurEffects = NO;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    dateSelectionController.datePicker.locale = locale;
    dateSelectionController.datePicker.minuteInterval = 1;
    dateSelectionController.datePicker.date = [NSDate date];
    
    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
//    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        //First we set the modal presentation style to the popover style
//        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
//
//        //Then we tell the popover presentation controller, where the popover should appear
//        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
//        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    }
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionController animated:YES completion:nil];
}



#pragma mark - RMPickerViewController Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataArray[row];
    return [NSString stringWithFormat:@"Row %lu", (long)row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%@",self.dataArray[row]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
