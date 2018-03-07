//
//  MemberView.h
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupViewModel.h"

@interface MemberView : UIView
@property (nonatomic, strong, readwrite)GroupViewModel *viewModel;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
