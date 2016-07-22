//
//  ViewController.m
//  CrashProbe tvOS
//
//  Created by Delisa on 7/21/16.
//  Copyright © 2016 Bit Stadium GmbH. All rights reserved.
//

#import "ViewController.h"
#import <CrashLib/CrashLib.h>
#import <objc/runtime.h>

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *crashButton;
@property (weak, nonatomic) IBOutlet UILabel *crashLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary <NSString *, NSArray<CRLCrash *>*>*knownCrashes;
@property (nonatomic, strong) NSArray <NSString *>*sortedAllKeys;
@end

@interface CRLTVCrashCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation CRLTVCrashCell
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cacheCrashes];
}

- (void)cacheCrashes {
    [self pokeAllCrashes];
    NSMutableArray *crashes = [NSMutableArray arrayWithArray:[CRLCrash allCrashes]];
    [crashes sortUsingComparator:^NSComparisonResult(CRLCrash *obj1, CRLCrash *obj2) {
        if ([obj1.category isEqualToString:obj2.category]) {
            return [obj1.title compare:obj2.title];
        } else {
            return [obj1.category compare:obj2.category];
        }
    }];

    NSMutableDictionary *categories = @{}.mutableCopy;

    for (CRLCrash *crash in crashes)
        categories[crash.category] = [(categories[crash.category] ?: @[]) arrayByAddingObject:crash];
    
    self.knownCrashes = categories.copy;
    NSMutableArray *result = [NSMutableArray arrayWithArray:self.knownCrashes.allKeys];

    [result sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];

    self.sortedAllKeys = [result copy];
}

- (void)pokeAllCrashes {
    unsigned int nclasses = 0;
    Class *classes = objc_copyClassList(&nclasses);

    for (unsigned int i = 0; i < nclasses; ++i) {
        if (classes[i] &&
            class_getSuperclass(classes[i]) == [CRLCrash class] &&
            class_respondsToSelector(classes[i], @selector(methodSignatureForSelector:)) &&
            classes[i] != [CRLCrash class])
        {
            [CRLCrash registerCrash:[[classes[i] alloc] init]];
        }
    }
    free(classes);
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    for (UIPress *press in presses) {
        if (press.type == UIPressTypePlayPause)
            [self doCrash:nil];
    }
}

- (IBAction)doCrash:(id)sender {
    if (!self.tableView.indexPathForSelectedRow)
        return;
    [[self crashAtIndexPath:self.tableView.indexPathForSelectedRow] crash];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (NSInteger)self.knownCrashes.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self titleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CRLTVCrashCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.titleLabel.text = [self crashAtIndexPath:indexPath].title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.knownCrashes[[self titleForSection:section]].count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CRLCrash *crash = [self crashAtIndexPath:indexPath];
    self.crashLabel.text = crash.desc;
}

- (CRLCrash *)crashAtIndexPath:(NSIndexPath *)indexPath {
    return self.knownCrashes[[self titleForSection:indexPath.section]][(NSUInteger)indexPath.row];
}

- (NSString *)titleForSection:(NSInteger)section {
    return self.sortedAllKeys[(NSUInteger)section];
}

@end
