//
//  GroupViewModel.m
//  HaHaGo_Test
//
//  Created by nerochiu on 2018/3/5.
//  Copyright © 2018年 ISCOM. All rights reserved.
//

#import "GroupViewModel.h"
#import "Firebase.h"

@interface GroupViewModel()


@property(nonatomic, strong) NSMutableArray *muDataArray;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) FIRDatabaseReference *refB;

@end

@implementation GroupViewModel

-(instancetype)init{
    
    if(self = [super init]){
        _muDataArray = [NSMutableArray array];
        _muSearchArray = [NSMutableArray array];
        _muJoinArray = [NSMutableArray array];
       _ref = [[FIRDatabase database] reference];
       _refB = [_ref child:@"hahago-test"];
        
    }
    
    return self;
}


-(void)getDataFromFirebase{
//
//    [_ref
//     observeEventType:FIRDataEventTypeChildAdded
//     withBlock:^(FIRDataSnapshot *snapshot) {
//        NSLog(@"snapshot=%@",(NSDictionary*)snapshot.value);
//        [self.muDataArray addObject:(NSMutableDictionary*)snapshot.value];
//         self.muSearchArray = [self.muDataArray mutableCopy];
//         self.isFresh=@1;
//     }];

    
  [_ref observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
      
      for(FIRDataSnapshot* child in snapshot.children.allObjects){
          NSLog(@"child.value = %@",child.value);
          NSDictionary *values = child.value;
         [self.muDataArray addObject:(NSDictionary*)values];
      }
      
         self.muSearchArray = [self.muDataArray mutableCopy];
         self.isFresh=@1;
     }];

    
}


-(NSArray *)dataArray{
    
    return [_muDataArray copy];
    
}

@end
