//
//  GPCommentViewController.m
//  礼物说
//
//  Created by tripleCC on 15/10/17.
//  Copyright © 2015年 tripleCC. All rights reserved.
//

#import "GPCommentViewController.h"
#import "GPDetailGiftCell.h"
#import "GPGiftComment.h"
#import "GPNetworkTool.h"

@interface GPCommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerViewBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *comments;
@property (strong, nonatomic) NSString *nextPageURLString;
@end

static NSString * const commentIdentifier = @"comment";

@implementation GPCommentViewController

#pragma mark 懒加载
- (NSMutableArray *)comments
{
    if (_comments == nil) {
        _comments = @[].mutableCopy;
    }
    
    return _comments;
}

#pragma mark 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupRefresh];
    [self setupNav];
}

- (void)dealloc {
    [[GPNetworkTool sharedNetworkTool].operationQueue cancelAllOperations];
}

- (void)setupNav {
    self.navigationItem.title = @"评论";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:self.commentTextField];
}

- (void)setupTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GPDetailGiftCell class]) bundle:nil] forCellReuseIdentifier:commentIdentifier];
}

- (void)setupRefresh {
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView.header beginRefreshing];
    self.tableView.footer.hidden = YES;
}

#pragma mark 加载数据

- (void)loadNewData {
    NSString *firstPageURLString = @"v1/posts/1001837/comments?limit=20&offset=0";
    
    [[GPNetworkTool sharedNetworkTool] GET:firstPageURLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        self.comments = [GPGiftComment objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]];
        NSString *nextURLString = responseObject[@"data"][@"paging"][@"next_url"];
        if ([nextURLString isKindOfClass:[NSNull class]] || [self.nextPageURLString isEqualToString:nextURLString]) {
            // 如果nextURLString是值为空的对象，就将self.nextPageURLString赋值为空对象
            // 注意nil和Null对象的区别，一个是空对象，一个是值为空的对象
            self.nextPageURLString = nil;
        } else {
            self.nextPageURLString = nextURLString;
        }
        
        [self.tableView.header endRefreshing];
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        TPCLog(@"%@", error);
        [self.tableView.header endRefreshing];
    }];
}

- (void)loadMoreData {
    
    [[GPNetworkTool sharedNetworkTool] GET:self.nextPageURLString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [self.comments addObjectsFromArray:[GPGiftComment objectArrayWithKeyValuesArray:responseObject[@"data"][@"comments"]]];
        NSString *nextURLString = responseObject[@"data"][@"paging"][@"next_url"];
        if ([nextURLString isKindOfClass:[NSNull class]] || [self.nextPageURLString isEqualToString:nextURLString]) {
            // 如果nextURLString是值为空的对象，就将self.nextPageURLString赋值为空对象
            // 注意nil和Null对象的区别，一个是空对象，一个是值为空的对象
            self.nextPageURLString = nil;
        } else {
            self.nextPageURLString = nextURLString;
        }
        
        [self.tableView reloadData];
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        TPCLog(@"%@", error);
        [self checkFooterState];
    }];

}

- (void)checkFooterState {
    if (self.nextPageURLString == nil) {
        //        [self.tableView.footer noticeNoMoreData];
        self.tableView.footer.hidden = YES;
    } else {
        [self.tableView.footer endRefreshing];
    }
}

- (IBAction)sendClicked:(id)sender {
    NSLog(@"发送评论");
}
#pragma mark 通知回调

- (void)textFieldChanged {
    self.sendButton.selected = self.commentTextField.hasText;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    self.inputContainerViewBottomConstraint.constant = TPCScreenH - keyboardFrame.origin.y;
    [self.view layoutIfNeeded];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPDetailGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:commentIdentifier];
    cell.comment = self.comments[indexPath.row];
    
    return  cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GPGiftComment *comment = self.comments[indexPath.row];
    self.commentTextField.placeholder = [NSString stringWithFormat:@"回复 %@", comment.nickname];
    self.commentTextField.text = @"";
    self.sendButton.selected = self.commentTextField.hasText;
    [self.commentTextField becomeFirstResponder];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    self.commentTextField.placeholder = @"输入评论...";
}
@end
