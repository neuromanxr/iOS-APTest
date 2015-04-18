//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"
#import "UIImageView+AFNetworking.h"

@interface ChatCell ()
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;

@property (strong, nonatomic) IBOutlet UIImageView *userAvatar;


@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;
    
    // circle profile
    self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.width / 2;
    self.userAvatar.clipsToBounds = YES;
    [self.userAvatar setImageWithURL:[NSURL URLWithString:chatData.avatar_url]];
}
@end
