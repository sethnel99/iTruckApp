//
// PFFacebookUtils.h
// Copyright (c) 2012 Parse, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PF_Facebook.h"
#import "PFUser.h"
#import "PFConstants.h"

/*!
 Provides utility functions for working with Facebook in a Parse application.
 */
@interface PFFacebookUtils : NSObject

/*!
 Gets the instance of the Facebook object (from the Facebook SDK) that Parse uses. 
 @result The Facebook instance.
 */
+ (PF_Facebook *)facebook;

/*!
 Gets the instance of the Facebook object (from the Facebook SDK) that Parse uses. 
 @param delegate Specify your own delegate for the Facebook object.
 @result The Facebook instance
 */
+ (PF_Facebook *)facebookWithDelegate:(NSObject<PF_FBSessionDelegate> *)delegate;

/*!
 Whether the user has their account linked to Facebook.
 @param user User to check for a facebook link. The user must be logged in on this device.
 @result True if the user has their account linked to Facebook.
 */
+ (BOOL)isLinkedWithUser:(PFUser *)user;

/*!
 Initializes the Facebook singleton. You must invoke this in order to use the Facebook functionality in Parse.
 @param applicationId The Facebook application id that you are using with your Parse application.
 */
+ (void)initializeWithApplicationId:(NSString *)appId;

/*!
 Unlinks the PFUser from a Facebook account. 
 @param user User to unlink from Facebook.
 @result Returns true if the unlink was successful.
 */
+ (BOOL)unlinkUser:(PFUser *)user;

/*!
 Unlinks the PFUser from a Facebook account. 
 @param user User to unlink from Facebook.
 @param error Error object to set on error.
 @result Returns true if the unlink was successful.
 */
+ (BOOL)unlinkUser:(PFUser *)user error:(NSError **)error;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook.
 */
+ (void)unlinkUserInBackground:(PFUser *)user;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook.
 @param block The block to execute. The block should have the following argument signature: (BOOL succeeded, NSError *error) 
 */
+ (void)unlinkUserInBackground:(PFUser *)user block:(PFBooleanResultBlock)block;

/*!
 Makes an asynchronous request to unlink a user from a Facebook account. 
 @param user User to unlink from Facebook
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchrounous request is complete.
 */
+ (void)unlinkUserInBackground:(PFUser *)user target:(id)target selector:(SEL)selector;

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions;

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param block The block to execute. The block should have the following argument signature:
 (BOOL *success, NSError *error) 
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions block:(PFBooleanResultBlock)block;

/*!
 Links Facebook to an existing PFUser. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically links the account to the PFUser.
 The selector for the callback should look like: (NSNumber *)result error:(NSError *)error
 @param user User to link to Facebook.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchrounous request is complete.
 */
+ (void)linkUser:(PFUser *)user permissions:(NSArray *)permissions target:(id)target selector:(SEL)selector;

/*!
 Logs in a user using Facebook. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically logs in (or creates, in the case where it is a new user)
 a PFUser.
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param block The block to execute. The block should have the following argument signature:
 (PFUser *user, NSError *error) 
 */
+ (void)logInWithPermissions:(NSArray *)permissions block:(PFUserResultBlock)block;

/*!
 Logs in a user using Facebook. This method delegates to the Facebook SDK to authenticate
 the user, and then automatically logs in (or creates, in the case where it is a new user)
 a PFUser. The selector for the callback should look like: (PFUser *)user error:(NSError **)error
 @param permissions The permissions required for Facebook log in. This passed to the authorize method on 
 the Facebook instance.
 @param target Target object for the selector
 @param selector The selector that will be called when the asynchrounous request is complete.
 */
+ (void)logInWithPermissions:(NSArray *)permissions target:(id)target selector:(SEL)selector;

/*!
 Handles URLs being opened by your AppDelegate. Invoke and return this from application:handleOpenURL:
 or application:openURL:sourceApplication:annotation in your AppDelegate.
 @param url URL being opened by your application.
 @result True if Facebook will handle this URL.
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

@end
