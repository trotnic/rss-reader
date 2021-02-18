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

Class registerClass(NSString *name) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL _userDefaults_sel   = NSSelectorFromString(@"userDefaults");
        SEL _repository_sel     = NSSelectorFromString(@"repository");
        SEL _rssLinks_sel       = NSSelectorFromString(@"rssLinks");
        SEL _saveState_sel      = NSSelectorFromString(@"saveState:");
        SEL _selectedLink_sel   = NSSelectorFromString(@"selectedLink");
        SEL _selectLink_sel     = NSSelectorFromString(@"selectLink:");
        SEL _updateLink_sel     = NSSelectorFromString(@"updateLink:");
        SEL _deleteLink_sel     = NSSelectorFromString(@"deleteLink:");
        SEL _insertLink_sel     = NSSelectorFromString(@"insertLink:relativeToURL:");
        SEL _links_sel          = NSSelectorFromString(@"links");
        
        Class manager_class = objc_allocateClassPair([NSObject class], name.UTF8String, 0);
        
        class_addIvar(manager_class, "_rssLinks", sizeof(NSMutableArray<RSSLink *>*), _Alignof(NSMutableArray<RSSLink *> *), @encode(NSMutableArray<RSSLink *> *));
        class_addIvar(manager_class, "_repository", sizeof(id<UVPListRepositoryType>), _Alignof(id<UVPListRepositoryType>), @encode(id<UVPListRepositoryType>));
        class_addIvar(manager_class, "_userDefaults", sizeof(NSUserDefaults *), _Alignof(NSUserDefaults *), @encode(NSUserDefaults *));
        
        Ivar _rssLinks_ivar = class_getInstanceVariable(manager_class, "_rssLinks");
        Ivar _repository_ivar = class_getInstanceVariable(manager_class, "_repository");
        Ivar _userDefaults_ivar = class_getInstanceVariable(manager_class, "_userDefaults");
        
        IMP _rssLinks_imp = imp_implementationWithBlock(^id(id self){
            id _rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
            if (!_rssLinks_ref) {
                id<UVPListRepositoryType> _repository_ref = [self performSelector:_repository_sel];
                NSError *error = nil;
                NSArray<NSDictionary *> *links = [_repository_ref fetchData:&error];
                if (links && !error) {
                    NSMutableArray *newLinks = [[links map:^id _Nonnull(NSDictionary *rawLink) {
                        return [RSSLink objectWithDictionary:rawLink];
                    }] mutableCopy];
                    object_setIvarWithStrongDefault(self, _rssLinks_ivar, [newLinks autorelease]);
                    return object_getIvar(self, _rssLinks_ivar);
                } else {
                    NSMutableArray *newLinks = [NSMutableArray array];
                    object_setIvarWithStrongDefault(self, _rssLinks_ivar, newLinks);
                    return object_getIvar(self, _rssLinks_ivar);
                }
            }
            return _rssLinks_ref;
        });
        const char *_rssLink_types = "@@:";
        class_addMethod(manager_class, _rssLinks_sel, _rssLinks_imp, _rssLink_types);
        
        IMP _repository_imp = imp_implementationWithBlock(^id(id self){
            id _repository_ref = object_getIvar(self, _repository_ivar);
            if (!_repository_ref) {
                NSUserDefaults *_userDefaults_ref = [self performSelector:_userDefaults_sel];
                NSString *path = [_userDefaults_ref objectForKey:kSourcesFilePathKey];
                id repository = [[UVSourceRepository alloc] initWithPath:path];
                object_setIvarWithStrongDefault(self, _repository_ivar, [repository autorelease]);
                return object_getIvar(self, _repository_ivar);
            }
            return _repository_ref;
        });
        const char *_repository_types = "@@:";
        class_addMethod(manager_class, _repository_sel, _repository_imp, _repository_types);
        
        IMP _userDefaults_imp = imp_implementationWithBlock(^id(id self){
            id _userDefaults_ref = object_getIvar(self, _userDefaults_ivar);
            if (!_userDefaults_ref) {
                id ud = NSUserDefaults.standardUserDefaults;
                object_setIvarWithStrongDefault(self, _userDefaults_ivar, ud);
                return object_getIvar(self, _userDefaults_ivar);
            }
            return _userDefaults_ref;
        });
        const char *_userDefaults_types = "@@:";
        class_addMethod(manager_class, _userDefaults_sel, _userDefaults_imp, _userDefaults_types);
        
        IMP _saveState_imp = imp_implementationWithBlock(^BOOL(id self, NSError **error){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            NSArray<NSDictionary *> *rawLinks = [_rssLinks_ref compactMap:^NSDictionary *(RSSLink *link) {
                return [link dictionaryFromObject];
            }];
            
            id<UVPListRepositoryType> _repository_ref = [self performSelector:_repository_sel];
            return [_repository_ref updateData:rawLinks error:error];
        });
        const char *_saveState_types = "c@:@";
        class_addMethod(manager_class, _saveState_sel, _saveState_imp, _saveState_types);
        
        IMP _selectedLink_imp = imp_implementationWithBlock(^RSSLink *(id self){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            RSSLink *link = [[_rssLinks_ref filter:^BOOL(RSSLink *link) {
                return link.isSelected;
            }] firstObject];
            
            if (!link && _rssLinks_ref.count > 0) {
                [_rssLinks_ref.firstObject setSelected:YES];
                return _rssLinks_ref.firstObject;
            }
            return link;
        });
        const char *_selectedLink_types = "@@:";
        class_addMethod(manager_class, _selectedLink_sel, _selectedLink_imp, _selectedLink_types);
        
        IMP _selectLink_imp = imp_implementationWithBlock(^void(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref forEach:^(RSSLink *link) {
                link.selected = NO;
            }];
            link.selected = YES;
        });
        const char *selectLink_types = "v@:@";
        class_addMethod(manager_class, _selectLink_sel, _selectLink_imp, selectLink_types);
        
        IMP _updateLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref enumerateObjectsUsingBlock:^(RSSLink *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqual:link]) _rssLinks_ref[idx] = link;
            }];
        });
        const char *_updateLink_types = "v@:@";
        class_addMethod(manager_class, _updateLink_sel, _updateLink_imp, _updateLink_types);
        
        IMP _deleteLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref removeObject:link];
        });
        const char *_deleteLink_types = "v@:@";
        class_addMethod(manager_class, _deleteLink_sel, _deleteLink_imp, _deleteLink_types);
        
        IMP _insertLink_imp = imp_implementationWithBlock(^(id self , NSDictionary *rawLink, NSURL *url){
            // TODO: -
            NSMutableArray *_rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
            
            RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
            ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
            if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
                ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
            };
            
            object_setIvar(self, _rssLinks_ivar, _rssLinks_ref);
        });
        const char *insertLink_types = "v@:@@";
        class_addMethod(manager_class, _insertLink_sel, _insertLink_imp, insertLink_types);
        
        IMP _links_imp = imp_implementationWithBlock(^NSArray *(id self){
            return [self performSelector:_rssLinks_sel];
        });
        const char *_links_types = "@@:";
        class_addMethod(manager_class, _links_sel, _links_imp, _links_types);
        
        IMP _dealloc_imp = imp_implementationWithBlock(^(id self){
            [object_getIvar(self, _repository_ivar) release];
            [object_getIvar(self, _rssLinks_ivar) release];            
            [object_getIvar(self, _userDefaults_ivar) release];
            
            struct objc_super super_entity = {
                self,
                class_getSuperclass(manager_class)
            };
            
            [((id)(&super_entity)) dealloc];
        });
        const char *_dealloc_types = "v@:";
        class_addMethod(manager_class, @selector(dealloc), _dealloc_imp, _dealloc_types);
        
        objc_registerClassPair(manager_class);
    });
    return NSClassFromString(name);
}
