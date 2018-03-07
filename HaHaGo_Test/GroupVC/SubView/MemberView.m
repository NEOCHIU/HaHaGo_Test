//
//  MemberView.m
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import "MemberView.h"
#import "MemberCell.h"
#import "UIImageView+WebCache.h"

@interface MemberView()<UICollectionViewDataSource, UICollectionViewDelegate>



@property (strong, nonatomic) IBOutlet UIView *avatarView;


@end

@implementation MemberView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"MemberView" owner:self options:nil] lastObject];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        flowLayout.minimumLineSpacing = 50;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

        [_collectionView registerNib:[UINib nibWithNibName:@"MemberCell" bundle:nil] forCellWithReuseIdentifier:@"MemberCell"];
    }
    
    return self;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"_viewModel.muJoinArray=%lu",(unsigned long)_viewModel.muJoinArray.count);
    
    if(_viewModel.muJoinArray.count>0){
        self.avatarView.hidden=YES;
    }else{
        self.avatarView.hidden=NO;
    }
    return  [_viewModel.muJoinArray count];;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   MemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MemberCell" forIndexPath:indexPath];

    [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:self.viewModel.muJoinArray[indexPath.row][@"photo"]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.avatarImg.layer.masksToBounds=YES;
    cell.avatarImg.layer.cornerRadius=cell.avatarImg.frame.size.width /2;
    
    //title
    cell.titleLabel.text = self.viewModel.muJoinArray[indexPath.row][@"name"];
    
    
    
    return cell;
}

- (void)setViewModel:(GroupViewModel *)viewModel{
    _viewModel = viewModel;
    
    //[_collectionView reloadData];
    
}

@end
