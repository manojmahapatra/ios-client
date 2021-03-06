//
//  Copyright © 2015 Catamorphic Co. All rights reserved.
//


#import "LDUserBuilder.h"
#import "LDUtil.h"
#import "LDDataManager.h"

@implementation LDUserBuilder

+ (LDUserModel *)compareNewBuilder:(LDUserBuilder *)iBuilder withUser:(LDUserModel *)iUser {
    if (iBuilder.key) {
        iUser.key = iBuilder.key;
    }
    if (iBuilder.ip || iUser.ip) {
        iUser.ip = iBuilder.ip;
    }
    if (iBuilder.country || iUser.country) {
        iUser.country = iBuilder.country;
    }
    if (iBuilder.name || iUser.name) {
        iUser.name = iBuilder.name;
    }
    if (iBuilder.firstName || iUser.firstName) {
        iUser.firstName = iBuilder.firstName;
    }
    if (iBuilder.lastName || iUser.lastName) {
        iUser.lastName = iBuilder.lastName;
    }
    if (iBuilder.email || iUser.email) {
        iUser.email = iBuilder.email;
    }
    if (iBuilder.avatar || iUser.avatar) {
        iUser.avatar = iBuilder.avatar;
    }
    if ((iBuilder.customDictionary && iBuilder.customDictionary.count) || (iUser.custom && iUser.custom.count)) {
        iUser.custom = iBuilder.customDictionary;
    }
    iUser.anonymous = iBuilder.isAnonymous;
    if (iBuilder.privateAttributes || iUser.privateAttributes) {
        iUser.privateAttributes = iBuilder.privateAttributes;
    }

    return iUser;
}

+(LDUserBuilder *)retrieveCurrentBuilder:(LDUserModel *)iUser {
    return [LDUserBuilder currentBuilder:iUser];
}

+ (LDUserBuilder *)currentBuilder:(LDUserModel *)iUser {
    LDUserBuilder *userBuilder = [[LDUserBuilder alloc] init];

    if (iUser.key) {
        userBuilder.key = iUser.key;
    }
    if (iUser.ip) {
        userBuilder.ip = iUser.ip;
    }
    if (iUser.country) {
        userBuilder.country = iUser.country;
    }
    if (iUser.name) {
        userBuilder.name = iUser.name;
    }
    if (iUser.firstName) {
        userBuilder.firstName = iUser.firstName;
    }
    if (iUser.lastName) {
        userBuilder.lastName = iUser.lastName;
    }
    if (iUser.email) {
        userBuilder.email = iUser.email;
    }
    if (iUser.avatar) {
        userBuilder.avatar = iUser.avatar;
    }
    if (iUser.custom && iUser.custom.count) {
        userBuilder.customDictionary = [iUser.custom mutableCopy];
    }
    userBuilder.isAnonymous = iUser.anonymous;
    if (iUser.privateAttributes) {
        userBuilder.privateAttributes = iUser.privateAttributes;
    }

    return userBuilder;
}

- (id)init {
    self = [super init];
    _customDictionary = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)customString:(NSString *)inputKey value:(NSString *)value
{
    if (!self.customDictionary) {
        return;
    }
    self.customDictionary[inputKey] = value;
}

- (void)customBool:(NSString *)inputKey value:(BOOL)value
{
    if (!self.customDictionary) {
        return;
    }
    self.customDictionary[inputKey] = [NSNumber numberWithBool:value];
}

- (void)customNumber:(NSString *)inputKey value:(NSNumber *)value
{
    if (!self.customDictionary) {
        return;
    }
    self.customDictionary[inputKey] = value;
}

- (void)customArray:(NSString *)inputKey value:(NSArray *)value
{
    if (!inputKey || !value) {
        return;
    }

    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (id myArrayElement in value) {
        if ([myArrayElement isKindOfClass:[NSString class]]) {
            [resultArray addObject:myArrayElement];
        } else if ([myArrayElement isKindOfClass:[NSNumber class]]) {
            [resultArray addObject:myArrayElement];
        } else if (myArrayElement) {
            [resultArray addObject:[NSNumber numberWithBool:YES]];
        } else {
            [resultArray addObject:[NSNumber numberWithBool:NO]];
        }
    }

    if (resultArray.count) {
        self.customDictionary[inputKey] = resultArray;
    }
}

- (LDUserModel *)build {
    DEBUG_LOGX(@"LDUserBuilder build method called");
    LDUserModel *user = nil;

    if (self.key) {
        user = [[LDDataManager sharedManager] findUserWithkey:self.key];
        if(!user) {
            user = [[LDUserModel alloc] init];
        }
        DEBUG_LOG(@"LDUserBuilder building User with key: %@", self.key);
        DEBUG_LOG(@"LDUserBuilder building User with anonymous: %d", self.isAnonymous);
        [user key:self.key];
        user.anonymous = self.isAnonymous;
    } else {
        NSString *uniqueKey;
#if TARGET_OS_IOS || TARGET_OS_TV
        uniqueKey = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
#else
        if ([[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifierKey]) {
            uniqueKey = [[NSUserDefaults standardUserDefaults] valueForKey:kDeviceIdentifierKey];
        }
        else{
            uniqueKey = [[NSUUID UUID] UUIDString];
            [[NSUserDefaults standardUserDefaults] setValue:uniqueKey forKey:kDeviceIdentifierKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

#endif
        DEBUG_LOG(@"LDUserBuilder building User with key: %@", uniqueKey);

        user = [[LDUserModel alloc] init];
        [user key:uniqueKey];
        user.anonymous = YES;
    }
    if (self.ip) {
        DEBUG_LOG(@"LDUserBuilder building User with ip: %@", self.ip);
        user.ip = self.ip;
    }
    if (self.country) {
        DEBUG_LOG(@"LDUserBuilder building User with country: %@", self.country);
        user.country = self.country;
    }
    if (self.name) {
        DEBUG_LOG(@"LDUserBuilder building User with name: %@", self.name);
        user.name = self.name;
    }
    if (self.firstName) {
        DEBUG_LOG(@"LDUserBuilder building User with firstName: %@", self.firstName);
        user.firstName = self.firstName;
    }
    if (self.lastName) {
        DEBUG_LOG(@"LDUserBuilder building User with lastName: %@", self.lastName);
        user.lastName = self.lastName;
    }
    if (self.email) {
        DEBUG_LOG(@"LDUserBuilder building User with email: %@", self.email);
        user.email = self.email;
    }
    if (self.avatar) {
        DEBUG_LOG(@"LDUserBuilder building User with avatar: %@", self.avatar);
        user.avatar = self.avatar;
    }
    if (self.customDictionary && self.customDictionary.count) {
        DEBUG_LOG(@"LDUserBuilder building User with custom: %@", self.customDictionary);
        user.custom = self.customDictionary;
    }
    if (self.privateAttributes) {
        DEBUG_LOG(@"LDUserBuilder building User with private attributes: %@", [self.privateAttributes description]);
        user.privateAttributes = self.privateAttributes;
    }

    [[LDDataManager sharedManager] saveUser:user];
    return user;
}

- (LDUserBuilder *)withKey:(NSString *)inputKey
{
    _key = inputKey;
    return self;
}

- (LDUserBuilder *)withIp:(NSString *)inputIp
{
    _ip = inputIp;
    return self;
}

- (LDUserBuilder *)withCountry:(NSString *)inputCountry
{
    _country = inputCountry;
    return self;
}

- (LDUserBuilder *)withName:(NSString *)inputName
{
    _name = inputName;
    return self;
}

- (LDUserBuilder *)withFirstName:(NSString *)inputFirstName
{
    _firstName = inputFirstName;
    return self;
}

- (LDUserBuilder *)withLastName:(NSString *)inputLastName
{
    _lastName = inputLastName;
    return self;
}

- (LDUserBuilder *)withEmail:(NSString *)inputEmail
{
    _email = inputEmail;
    return self;
}

- (LDUserBuilder *)withAvatar:(NSString *)inputAvatar
{
    _avatar = inputAvatar;
    return self;
}

- (LDUserBuilder *)withCustomString:(NSString *)inputKey value:(NSString *)value
{
    [_customDictionary setObject:value forKey:inputKey];
    return self;
}

- (LDUserBuilder *)withCustomBool:(NSString *)inputKey value:(BOOL)value
{
    [_customDictionary setObject:[NSNumber numberWithBool:value] forKey:inputKey];
    return self;
}

- (LDUserBuilder *)withCustomNumber:(NSString *)inputKey value:(NSNumber *)value
{
    [_customDictionary setObject:value forKey:inputKey];
    return self;
}

- (LDUserBuilder *)withCustomArray:(NSString *)inputKey value:(NSArray *)value
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (id myArrayElement in value) {
        if ([myArrayElement isKindOfClass:[NSString class]]) {
            [resultArray addObject:myArrayElement];
        } else if ([myArrayElement isKindOfClass:[NSNumber class]]) {
            [resultArray addObject:myArrayElement];
        } else if (myArrayElement) {
            [resultArray addObject:[NSNumber numberWithBool:YES]];
        } else {
            [resultArray addObject:[NSNumber numberWithBool:NO]];
        }
    }
    if ([resultArray count]) {
        [_customDictionary setObject:resultArray forKey:inputKey];
    }
    return self;
}

- (LDUserBuilder *)withCustomDictionary:(NSMutableDictionary *)inputDictionary
{
    _customDictionary = inputDictionary;
    return self;
}

- (LDUserBuilder *)withAnonymous:(BOOL)inputAnonymous {
    _isAnonymous = inputAnonymous;
    return self;
}

@end
