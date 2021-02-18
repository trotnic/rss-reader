//
//  UVSourceManager.m
//  rss-reader
//
//  Created by Uladzislau Volchyk on 14.12.20.
//

#import "UVSourceManager.h"
#import "UVSourceRepository.h"

#import "NSArray+Util.h"

#import "UVErrorDomain.h"
#import "KeyConstants.h"

#import <objc/runtime.h>
#import <objc/message.h>

// MARK: -

//static void createClass(void);

// MARK: -

//static Class UVSourceManager;

@interface UVSMLoader : NSObject

@end

@implementation UVSMLoader

+ (void)load {
    [super load];
    //    createClass();
}

@end

void dealloc(id self, SEL _cmd) {
    Ivar _repository_ivar = class_getInstanceVariable(UVSourceManager, "_repository");
    id _repository_ref = object_getIvar(self, _repository_ivar);
    ((void(*)(id, SEL))objc_msgSend)(_repository_ref, @selector(release));
    
    Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, "_rssLinks");
    id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
    ((void(*)(id, SEL))objc_msgSend)(_rssLinks_ref, @selector(release));
    
    Ivar _userDefaults_ivar = class_getInstanceVariable(UVSourceManager, "_userDefaults");
    id _userDefaults_ref = object_getIvar(self, _userDefaults_ivar);
    ((void(*)(id, SEL))objc_msgSend)(_userDefaults_ref, @selector(release));
    
    
    struct objc_super super_entity = {
        self,
        class_getSuperclass(UVSourceManager)
    };
    
    ((void(*)(id, SEL))objc_msgSendSuper)((id)&super_entity, NSSelectorFromString(@"dealloc"));
}

NSArray<RSSLink *> * links(id self, SEL _cmd) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    //    id copy_links = ((id(^)(id, SEL))objc_msgSend)(_rssLinks_ref, @selector(copy));
    return _rssLinks_ref;
    //    return ((id(*)(id, SEL))objc_msgSend)(_rssLinks_ref, @selector(autorelease));
}

void insertLinks(id self, SEL _cmd, NSArray<NSDictionary *> *rawLinks, NSURL *url) {
    Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, "_rssLinks");
    id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
    
    NSArray *tmp = ((NSArray *(*)(id, SEL, RSSLink *(^)(NSDictionary *)))objc_msgSend)(rawLinks, @selector(compactMap:), ^(NSDictionary *rawLink){
        RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
        ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
        return link;
    });
    
    ((void(*)(id, SEL, void(^)(RSSLink *)))objc_msgSend)(tmp, @selector(forEach:), ^(RSSLink *link){
        if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
            ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
        };
    });
}

void insertLink(id self, SEL _cmd, NSDictionary *rawLink, NSURL *url) {
    Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, "_rssLinks");
    id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
    
    RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
    ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
    if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
        ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
    };
}

void deleteLink(id self, SEL _cmd, RSSLink *link) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(removeObject:), link);
}

void updateLink(id self, SEL _cmd, RSSLink *link) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    
    ((void(*)(id, SEL, void(^)(RSSLink *, NSUInteger, BOOL*)))objc_msgSend)(_rssLinks_ref, @selector(enumerateObjectsUsingBlock:), ^(RSSLink *obj, NSUInteger index, BOOL *stop){
        if (((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(isEqual:), link)) {
            ((void(*)(id, SEL, id, NSUInteger))objc_msgSend)(_rssLinks_ref, @selector(setObject:atIndexedSubscript:), link, index);
        }
    });
}

void selectLink(id self, SEL _cmd, RSSLink *link) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    
    ((void(*)(id, SEL, void(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(forEach:), ^(RSSLink *link){
        ((void(*)(id, SEL, BOOL))objc_msgSend)(link, @selector(setSelected:), NO);
    });
    ((void(*)(id, SEL, BOOL))objc_msgSend)(link, @selector(setSelected:), YES);
}

RSSLink *selectedLink(id self, SEL _cmd) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    
    NSArray *links = ((NSArray *(*)(id, SEL, BOOL(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(filter:), ^BOOL(RSSLink *link){
        return ((BOOL(*)(id, SEL))objc_msgSend)(link, @selector(isSelected));
    });
    RSSLink *link = ((RSSLink *(*)(id, SEL))objc_msgSend)(links, @selector(firstObject));
    if (!link && ((NSInteger(*)(id, SEL))objc_msgSend)(links, @selector(count)) > 0) {
        id firstObject = ((id(*)(id, SEL))objc_msgSend)(_rssLinks_ref, @selector(firstObject));
        
        ((void(*)(id, SEL, BOOL))objc_msgSend)(firstObject, @selector(setSelected:), YES);
        return firstObject;
    }
    return link;
}

BOOL saveState(id self, SEL _cmd, NSError **error) {
    id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
    
    NSArray<NSDictionary *> *rawLinks = ((NSArray *(*)(id, SEL, id(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(compactMap:), ^id(id link){
        return ((id(*)(id, SEL))objc_msgSend)(link, @selector(dictionaryFromObject));
    });
    
    id _repository_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"repository"));
    
    return ((BOOL(*)(id, SEL, NSArray *, NSError **))objc_msgSend)(_repository_ref, @selector(updateData:error:), rawLinks, error);
}

// MARK: - Lazy

NSMutableArray<RSSLink *> * rssLinks(id self, SEL _cmd) {
    Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, "_rssLinks");
    id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
    if (!_rssLinks_ref) {
        id _repository_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"repository"));
        //        Ivar _repository_ivar = class_getInstanceVariable(UVSourceManager, "_repository");
        //        id _repository_ref = object_getIvar(self, _repository_ivar);
        
        NSError *error = nil;
        NSArray<NSDictionary *> *links = ((id(*)(id, SEL, NSError **))objc_msgSend)(_repository_ref, @selector(fetchData:), &error);
        if (links && !error) {
            id newLinks = ((id(*)(id, SEL, id(^)(NSDictionary *)))objc_msgSend)(links, @selector(map:), ^id(NSDictionary *rawLink){
                return ((id(*)(id, SEL, id))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
            });
            object_setIvar(self, _rssLinks_ivar, newLinks);
            return object_getIvar(self, _rssLinks_ivar);
        } else {
            id newLinks = ((id(*)(id, SEL))objc_msgSend)(NSMutableArray.class, @selector(new));
            object_setIvar(self, _rssLinks_ivar, newLinks);
            return object_getIvar(self, _rssLinks_ivar);
        }
    }
    return _rssLinks_ref;
}

id<UVPListRepositoryType> repository(id self, SEL _cmd) {
    Ivar _repository_ivar = class_getInstanceVariable(UVSourceManager, "_repository");
    id _repository_ref = object_getIvar(self, _repository_ivar);
    if (!_repository_ref) {
        id _userDefaults_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"userDefaults"));
        NSString *path = ((id(*)(id, SEL, NSString *))objc_msgSend)(_userDefaults_ref, @selector(objectForKey:), kSourcesFilePathKey);
        id repository = ((id(*)(id, SEL))objc_msgSend)(UVSourceRepository.class, @selector(alloc));
        repository = ((id(*)(id, SEL, NSString *))objc_msgSend)(repository, @selector(initWithPath:), path);
        object_setIvar(self, _repository_ivar, repository);
        return object_getIvar(self, _repository_ivar);
    }
    return _repository_ref;
}

NSUserDefaults * userDefaults(id self, SEL _cmd) {
    Ivar _userDefaults_ivar = class_getInstanceVariable(UVSourceManager, "_userDefaults");
    id _userDefaults_ref = object_getIvar(self, _userDefaults_ivar);
    if (!_userDefaults_ref) {
        id ud = ((id(*)(id, SEL))objc_msgSend)(NSUserDefaults.class, @selector(standardUserDefaults));
        ud = ((id(*)(id, SEL))objc_msgSend)(ud, @selector(retain));
        object_setIvar(self, _userDefaults_ivar, ud);
        return object_getIvar(self, _userDefaults_ivar);
    }
    return _userDefaults_ref;
}

// MARK: -

id createSourceManager() {
    UVSourceManager = objc_allocateClassPair([NSObject class], "UVSourceManager", 0);
    
    class_addIvar(UVSourceManager, "_rssLinks", sizeof(NSMutableArray<RSSLink *>*), _Alignof(NSMutableArray<RSSLink *> *), @encode(NSMutableArray<RSSLink *> *));
    class_addIvar(UVSourceManager, "_repository", sizeof(id<UVPListRepositoryType>), _Alignof(id<UVPListRepositoryType>), @encode(id<UVPListRepositoryType>));
    class_addIvar(UVSourceManager, "_userDefaults", sizeof(NSUserDefaults *), _Alignof(NSUserDefaults *), @encode(NSUserDefaults *));
    
    Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, "_rssLinks");
    Ivar _repository_ivar = class_getInstanceVariable(UVSourceManager, "_repository");
    Ivar _userDefaults_ivar = class_getInstanceVariable(UVSourceManager, "_userDefaults");
    
    IMP _rssLinks_imp = imp_implementationWithBlock(^id(id self){
        id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
        if (!_rssLinks_ref) {
            id _repository_ref = [self performSelector:NSSelectorFromString(@"repository")];
            NSError *error = nil;
            
            NSArray<NSDictionary *> *links = ((id(*)(id, SEL, NSError **))objc_msgSend)(_repository_ref, @selector(fetchData:), &error);
            if (links && !error) {
                id newLinks = [links map:^id _Nonnull(NSDictionary *rawLink) {
                    return [RSSLink objectWithDictionary:rawLink];
                }];
                object_setIvar(self, _rssLinks_ivar, newLinks);
                return object_getIvar(self, _rssLinks_ivar);
            }
        }
        return _rssLinks_ref;
    });
    const char *rssLink_types =[[NSString stringWithFormat:@"%s%s%s", @encode(NSMutableArray *), @encode(id), @encode(SEL)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"rssLinks"), _rssLinks_imp, rssLink_types);
    
    IMP _repository_imp = imp_implementationWithBlock(^id(id self){
        id _repository_ref = object_getIvar(self, _repository_ivar);
        if (!_repository_ref) {
            id _userDefaults_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"userDefaults"));
            NSString *path = ((id(*)(id, SEL, NSString *))objc_msgSend)(_userDefaults_ref, @selector(objectForKey:), kSourcesFilePathKey);
            id repository = [[UVSourceRepository alloc] initWithPath:path];
            //            id repository = ((id(*)(id, SEL))objc_msgSend)(UVSourceRepository.class, @selector(alloc));
            //            repository = ((id(*)(id, SEL, NSString *))objc_msgSend)(repository, @selector(initWithPath:), path);
            object_setIvar(self, _repository_ivar, repository);
            return object_getIvar(self, _repository_ivar);
        }
        return _repository_ref;
    });
    const char *repository_types =[[NSString stringWithFormat:@"%s%s%s", @encode(id<UVPListRepositoryType>), @encode(id), @encode(SEL)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"repository"), _repository_imp, repository_types);
    
    IMP _userDefaults_imp = imp_implementationWithBlock(^id(id self){
        id _userDefaults_ref = object_getIvar(self, _userDefaults_ivar);
        if (!_userDefaults_ref) {
            id ud = ((id(*)(id, SEL))objc_msgSend)(NSUserDefaults.class, @selector(standardUserDefaults));
            ud = ((id(*)(id, SEL))objc_msgSend)(ud, @selector(retain));
            object_setIvar(self, _userDefaults_ivar, ud);
            return object_getIvar(self, _userDefaults_ivar);
        }
        return _userDefaults_ref;
    });
    const char *userDefaults_types =[[NSString stringWithFormat:@"%s%s%s", @encode(NSUserDefaults *), @encode(id), @encode(SEL)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"userDefaults"), _userDefaults_imp, userDefaults_types);
    
    IMP _saveState_imp = imp_implementationWithBlock(^BOOL(id self, NSError **error){
        id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        NSArray<NSDictionary *> *rawLinks = ((NSArray *(*)(id, SEL, id(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(compactMap:), ^id(id link){
            return ((id(*)(id, SEL))objc_msgSend)(link, @selector(dictionaryFromObject));
        });
        
        id _repository_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"repository"));
        
        return ((BOOL(*)(id, SEL, NSArray *, NSError **))objc_msgSend)(_repository_ref, @selector(updateData:error:), rawLinks, error);
    });
    const char *saveState_types =[[NSString stringWithFormat:@"%s%s%s%s", @encode(BOOL), @encode(id), @encode(SEL), @encode(NSError **)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"saveState:"), _saveState_imp, saveState_types);
    
    IMP _selectedLink_imp = imp_implementationWithBlock(^RSSLink *(id self){
        id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        
        NSArray *links = ((NSArray *(*)(id, SEL, BOOL(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(filter:), ^BOOL(RSSLink *link){
            return ((BOOL(*)(id, SEL))objc_msgSend)(link, @selector(isSelected));
        });
        RSSLink *link = ((RSSLink *(*)(id, SEL))objc_msgSend)(links, @selector(firstObject));
        if (!link && ((NSInteger(*)(id, SEL))objc_msgSend)(links, @selector(count)) > 0) {
            id firstObject = ((id(*)(id, SEL))objc_msgSend)(_rssLinks_ref, @selector(firstObject));
            
            ((void(*)(id, SEL, BOOL))objc_msgSend)(firstObject, @selector(setSelected:), YES);
            return firstObject;
        }
        return link;
    });
    const char *selectedLink_types =[[NSString stringWithFormat:@"%s%s%s", @encode(RSSLink *), @encode(id), @encode(SEL)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"selectedLink"), _selectedLink_imp, selectedLink_types);
    
    IMP _selectLink_imp = imp_implementationWithBlock(^void(id self, RSSLink *link){
        id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        
        ((void(*)(id, SEL, void(^)(RSSLink *)))objc_msgSend)(_rssLinks_ref, @selector(forEach:), ^(RSSLink *link){
            ((void(*)(id, SEL, BOOL))objc_msgSend)(link, @selector(setSelected:), NO);
        });
        ((void(*)(id, SEL, BOOL))objc_msgSend)(link, @selector(setSelected:), YES);
    });
    const char *selectLink_types = "v@:@";
//    const char *selectLink_types =[[NSString stringWithFormat:@"%s%s%s%s", @encode(void), @encode(id), @encode(SEL), @encode(RSSLink *)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"selectLink:"), _selectLink_imp, selectLink_types);
    
    IMP _updateLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
        id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        
        ((void(*)(id, SEL, void(^)(RSSLink *, NSUInteger, BOOL*)))objc_msgSend)(_rssLinks_ref, @selector(enumerateObjectsUsingBlock:), ^(RSSLink *obj, NSUInteger index, BOOL *stop){
            if (((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(isEqual:), link)) {
                ((void(*)(id, SEL, id, NSUInteger))objc_msgSend)(_rssLinks_ref, @selector(setObject:atIndexedSubscript:), link, index);
            }
        });
    });
    const char *updateLink_types =[[NSString stringWithFormat:@"%s%s%s%s", @encode(void), @encode(id), @encode(SEL), @encode(RSSLink *)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"updateLink:"), _updateLink_imp, updateLink_types);
    
    IMP _deleteLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
        id _rssLinks_ref = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(removeObject:), link);
    });
    const char *deleteLink_types =[[NSString stringWithFormat:@"%s%s%s%s", @encode(void), @encode(id), @encode(SEL), @encode(RSSLink *)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"deleteLink:"), _deleteLink_imp, deleteLink_types);
    
    IMP _insertLink_imp = imp_implementationWithBlock(^(id self, NSDictionary *rawLink, NSURL *url){
        id _rssLinks_ref = [object_getIvar(self, _rssLinks_ivar) mutableCopy];
        
        RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
        ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
        if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
            ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
        };
        
        object_setIvar(self, _rssLinks_ivar, _rssLinks_ref);
    });
//    const char *insertLink_types =[[NSString stringWithFormat:@"v32@0:8@16@24", @encode(void), @encode(id), @encode(SEL), @encode(NSDictionary *), @encode(NSURL *)]  UTF8String];
    const char *insertLink_types = "v32@0:8@16@24";
    class_addMethod(UVSourceManager, NSSelectorFromString(@"insertLink:relativeToURL:"), _insertLink_imp, insertLink_types);
    
//    IMP _insertLinks_imp = imp_implementationWithBlock(^void(id self, SEL _cmd, NSArray<NSDictionary *> *rawLinks, NSURL *url){
//        id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
//
//        NSArray *tmp = [rawLinks compactMap:^id(NSDictionary *rawLink) {
//            RSSLink *link = [RSSLink objectWithDictionary:rawLink];
//            [link configureURLRelativeToURL:url];
//            return link;
//        }];
////        NSArray *tmp = ((NSArray *(*)(id, SEL, RSSLink *(^)(NSDictionary *)))objc_msgSend)(rawLinks, @selector(compactMap:), ^(NSDictionary *rawLink){
////            RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
////            ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
////            return link;
////        });
//
//        ((void(*)(id, SEL, void(^)(RSSLink *)))objc_msgSend)(tmp, @selector(forEach:), ^(RSSLink *link){
//            if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
//                ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
//            };
//        });
//    });
//    const char *insertLinks_types = [[NSString stringWithFormat:@"%s%s%s8%s%s", @encode(void), @encode(id), @encode(SEL), @encode(NSArray<NSDictionary *> *), @encode(NSURL *)]  UTF8String];
//    const char *insertLinks_types = "v32@0:8@16@24";
//    class_addMethod(UVSourceManager, NSSelectorFromString(@"insertLinks:relativeToURL:"), _insertLinks_imp, insertLinks_types);
    
    IMP _links_imp = imp_implementationWithBlock(^NSArray *(id self){
        id rv = ((id(*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"rssLinks"));
        return ((id(*)(id, SEL))objc_msgSend)(rv, NSSelectorFromString(@"copy"));
    });
    const char *links_types =[[NSString stringWithFormat:@"%s%s%s", @encode(NSArray *), @encode(id), @encode(SEL)]  UTF8String];
    class_addMethod(UVSourceManager, NSSelectorFromString(@"links"), _links_imp, links_types);
    
    //    IMP insertLinks = imp_implementationWithBlock(^(id self, SEL _cmd, NSArray<NSDictionary *> *rawLinks, NSURL *url){
    //        NSArray *tmp = [rawLinks compactMap:^id _Nonnull(NSDictionary *rawLink) {
    //            RSSLink *link = [RSSLink objectWithDictionary:rawLink];
    //            [link configureURLRelativeToURL:url];
    //            return link;
    //        }];
    //        NSArray _rssLinks =
    //        [tmp forEach:^(RSSLink *link) {
    //            if (!)
    //        }];
    //    });
    
    //    class_addMethod(UVSourceManager, @selector(links), (IMP)links, "@@:");
    //    class_addMethod(UVSourceManager, @selector(insertLinks:relativeToURL:), (IMP)insertLinks, "v@:@:@");
    //    class_addMethod(UVSourceManager, @selector(insertLink:relativeToURL:), (IMP)insertLink, "v@:@:@");
    //    class_addMethod(UVSourceManager, @selector(updateLink:), (IMP)updateLink, "v@:@");
    //    class_addMethod(UVSourceManager, @selector(deleteLink:), (IMP)deleteLink, "v@:@");
    //    class_addMethod(UVSourceManager, @selector(selectLink:), (IMP)selectLink, "v@:@");
    //    class_addMethod(UVSourceManager, @selector(selectedLink), (IMP)selectedLink, "@@");
    //    class_addMethod(UVSourceManager, @selector(saveState:), (IMP)saveState, "c@:@");
    ////
    //    class_addMethod(UVSourceManager, NSSelectorFromString(@"repository"), (IMP)repository, "@@:");
    //    class_addMethod(UVSourceManager, NSSelectorFromString(@"rssLinks"), (IMP)rssLinks, "@@:");
    //    class_addMethod(UVSourceManager, NSSelectorFromString(@"userDefaults"), (IMP)userDefaults, "@@:");
    
    objc_registerClassPair(UVSourceManager);
    id source = [UVSourceManager new];
    return source;
    //    id links = [source links];
    //    return UVSourceManager;
    //    *class = &UVSourceManager;
}

// MARK: -
//@interface UVSourceManager ()
//
//@property (nonatomic, retain) NSMutableArray<RSSLink *> *rssLinks;
//@property (nonatomic, retain) id<UVPListRepositoryType> repository;
//
//@end
//
//@implementation UVSourceManager
//
//- (void)dealloc
//{
//    [_repository release];
//    [_rssLinks release];
//    [_userDefaults release];
//    [super dealloc];
//}
//
//// MARK: -
//
//- (NSArray<RSSLink *> *)links {
//    return [[self.rssLinks copy] autorelease];
//}
//
//- (void)insertLinks:(NSArray<NSDictionary *> *)rawLinks
//      relativeToURL:(NSURL *)url{
//    [[rawLinks compactMap:^RSSLink *(NSDictionary *rawLink) {
//        RSSLink *link = [RSSLink objectWithDictionary:rawLink];
//        [link configureURLRelativeToURL:url];
//        return link;
//    }] forEach:^(RSSLink *link) {
//        if (![self.rssLinks containsObject:link]) {
//            [self.rssLinks addObject:link];
//        }
//    }];
//}
//
//- (void)insertLink:(NSDictionary *)rawLink
//     relativeToURL:(NSURL *)url {
//    RSSLink *link = [RSSLink objectWithDictionary:rawLink];
//    [link configureURLRelativeToURL:url];
//    if (![self.rssLinks containsObject:link]) {
//        [self.rssLinks addObject:link];
//    }
//}
//
//- (void)deleteLink:(RSSLink *)link {
//    [self.rssLinks removeObject:link];
//}
//
//- (void)updateLink:(RSSLink *)link {
//    __block typeof(self)weakSelf = self;
//    [self.rssLinks enumerateObjectsUsingBlock:^(RSSLink *obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isEqual:link]) {
//            weakSelf.rssLinks[idx] = link;
//        }
//    }];
//}
//
//- (void)selectLink:(RSSLink *)link {
//    [self.rssLinks forEach:^(RSSLink *obj) {
//        obj.selected = NO;
//    }];
//    link.selected = YES;
//}
//
//- (RSSLink *)selectedLink {
//    RSSLink * link = [[self.rssLinks filter:^BOOL(RSSLink *obj) {
//        return obj.isSelected;
//    }] firstObject];
//    if (!link && self.rssLinks.count > 0) {
//        self.rssLinks.firstObject.selected = YES;
//        return self.rssLinks.firstObject;
//    }
//    return link;
//}
//
//- (BOOL)saveState:(out NSError **)error {
//    NSArray<NSDictionary *> *rawLinks = [self.rssLinks compactMap:^id (RSSLink *link) {
//        return link.dictionaryFromObject;
//    }];
//    return [self.repository updateData:rawLinks error:error];
//}
//
//// MARK: - Lazy
//
//- (NSMutableArray<RSSLink *> *)rssLinks {
//    if (!_rssLinks) {
//        NSError *error = nil;
//        NSArray<NSDictionary *> *links = [self.repository fetchData:&error];
//        if (links && !error) {
//            _rssLinks = [[links map:^id (NSDictionary *rawLink) {
//                return [RSSLink objectWithDictionary:rawLink];
//            }] mutableCopy];
//        } else {
//            _rssLinks = [NSMutableArray new];
//        }
//    }
//    return _rssLinks;
//}
//
//- (id<UVPListRepositoryType>)repository {
//    if(!_repository) {
//        NSString *path = [self.userDefaults objectForKey:kSourcesFilePathKey];
//        _repository = [[UVSourceRepository alloc] initWithPath:path];
//    }
//    return _repository;
//}
//
//- (NSUserDefaults *)userDefaults {
//    if(!_userDefaults) {
//        _userDefaults = [NSUserDefaults.standardUserDefaults retain];
//    }
//    return _userDefaults;
//}
//
//
//@end

