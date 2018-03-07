//
//  GroupViewController.m
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupViewModel.h"
#import "TableViewCell.h"
#import "FBKVOController.h"
#import "UIImageView+WebCache.h"
#import "MemberView.h"

@interface GroupViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *searchBar_Height;


@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)GroupViewModel *viewModel;
@property (nonatomic, assign)CGFloat marginTop;
@property (strong, nonatomic) IBOutlet UISearchBar *searchView;
@property (strong, nonatomic) IBOutlet UIView *memberBGView;
@property (nonatomic, strong, readwrite) MemberView *memberView;
@property (strong, nonatomic) IBOutlet UILabel *memberNum;
@property (strong, nonatomic) IBOutlet UILabel *friendNum;




@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViewConstraints];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    self.title=@"建立群組";
    _searchView.delegate=self;
    self.searchView.backgroundImage = [[UIImage alloc] init];
    [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].title = @"取消";
  //  self.searchView.barTintColor = [UIColor whiteColor];


    //隱藏多餘的cell
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //將table headerview 歸0 隱藏
    CGRect frame = CGRectMake(0,0,0,CGFLOAT_MIN);
    _tableView.tableHeaderView=[[UIView alloc] initWithFrame:frame];
  
   _tableView.rowHeight=65;

    [self configureView];
    [self KVOHandler];

}

-(void)configureView{
   
    [self.memberBGView addSubview:self.memberView];

  //  [self.memberBGView bringSubviewToFront:self.memberView];
}


-(void)KVOHandler{
  
    [self.KVOController observe:self.viewModel keyPath:@"isFresh" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        self.memberView.viewModel=self.viewModel;
        if ([self.viewModel.isFresh boolValue]) {
            [self.tableView reloadData];
            
        }
    }];
    
}

#pragma TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.viewModel.muSearchArray count]>0){
        NSMutableArray *tempArray = self.viewModel.muSearchArray;
        
        NSLog(@"tempArray=%lu",(unsigned long)tempArray.count);
        self.friendNum.text=[NSString stringWithFormat:@"%lu",(unsigned long)tempArray.count];
        return tempArray.count;
    }else{
        return 0;
    }
   return 0;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"TableViewCell";
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    CGRect rect;
    if(cell ==nil){
        UINib *nib =[UINib nibWithNibName:@"TableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell =[tableView dequeueReusableCellWithIdentifier:identifier];
        rect = cell.frame;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Avatar
    [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.viewModel.muSearchArray[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.avatarImg.layer.masksToBounds=YES;
    cell.avatarImg.layer.cornerRadius=cell.avatarImg.frame.size.width /2;
    
    //title
    cell.titleLabel.text = self.viewModel.muSearchArray[indexPath.row][@"name"];
    
    //Check
    if([self.viewModel.muSearchArray[indexPath.row][@"hasjoin"] boolValue]){
        cell.checkLabel.hidden=NO;
    }else{
        cell.checkLabel.hidden=YES;
    }
 

    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"you select = %ld",(long)indexPath.row);
    TableViewCell *cell =  [tableView cellForRowAtIndexPath:indexPath];

    
    if([self.viewModel.muSearchArray[indexPath.row][@"hasjoin"] boolValue]){
     
        [self.viewModel.muSearchArray[indexPath.row] setObject:@0 forKey:@"hasjoin"];
         cell.checkLabel.hidden=YES;
        
        NSString *uid = self.viewModel.muSearchArray[indexPath.row][@"name"];
        
        //delete data
        for(int i=0 ;i < self.viewModel.muJoinArray.count;i++ ){
            
            if([self.viewModel.muJoinArray[i][@"name"] isEqual:uid]){
                
                //NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:i];
   
                [_memberView.collectionView performBatchUpdates:^{
                    
                [self.viewModel.muJoinArray removeObjectAtIndex:i];
                    
                [_memberView.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                    
                }completion:^(BOOL finished){
                    
                    [_memberView.collectionView reloadData];
                 
                }];
                
            }
        }

    }else{
        [self.viewModel.muSearchArray[indexPath.row] setObject:@1 forKey:@"hasjoin"];
         cell.checkLabel.hidden=NO;
        [self.viewModel.muJoinArray addObject:self.viewModel.muSearchArray[indexPath.row]];
        
        [_memberView.collectionView reloadData];
        
//        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:self.viewModel.muJoinArray.count - 1];
//        [_memberView.collectionView insertItemsAtIndexPaths:@[indexPath]];
        
    }
       self.memberNum.text=[NSString stringWithFormat:@"%lu",(unsigned long)self.viewModel.muJoinArray.count];
    
}


#pragma searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
    [self.viewModel.muSearchArray removeAllObjects];
    
    if([searchText length] != 0) {
        [self searchTableList];
    }
    else {
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.viewModel.muSearchArray removeAllObjects];
    [self searchTableList];
    [searchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
   
    [searchBar resignFirstResponder];
    [self.viewModel.muSearchArray removeAllObjects];
    self.viewModel.muSearchArray = [self.viewModel.dataArray mutableCopy];
    [self.tableView reloadData];
    
}

- (void)searchTableList {
    NSString *searchString = _searchView.text;
    
    for (NSDictionary *dataDic in self.viewModel.dataArray) {
        NSComparisonResult result = [dataDic[@"name"] compare:searchString options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchString length])];
        if (result == NSOrderedSame) {
            [self.viewModel.muSearchArray addObject:dataDic];
        }
    }
    [self.tableView reloadData];
}


#pragma scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    NSLog(@"newoffsetY=%f",newoffsetY);
    
    [UIView animateWithDuration:1 animations:^{
        if (newoffsetY <= 0) {
            
            self.searchBar_Height.constant= 56;
        }else if (newoffsetY >= 5 && newoffsetY <= 100){
            self.searchBar_Height.constant= 0;
            
        }
    }];

    

}


-(GroupViewModel*)viewModel{
    if(!_viewModel){
        _viewModel = [[GroupViewModel alloc]init];

        [_viewModel getDataFromFirebase];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        
    }
    return _viewModel;
}


-(MemberView*)memberView{
    if(!_memberView){
        _memberView = [[MemberView alloc]init];
        _memberView.frame=CGRectMake(0, 0, _memberBGView.frame.size.width, _memberBGView.frame.size.height);
    

    }
    return _memberView;
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
