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

static const char *const kClassName              = "UVSourceManager";

static const char *const kUserDefaultsIvar_name  = "_userDefaults";
static const char *const kRepositoryIvar_name    = "_repository";
static const char *const kRSSLinksIvar_name      = "_rssLinks";

static const char *const kRSSLinksGet_name       = "rssLinks";
static const char *const kUserDefaultsGet_name   = "userDefaults";
static const char *const kRepositoryGet_name     = "repository";

Class UVSourceManager;
void registerClass(void);

@interface InternalLoader : NSObject @end

@implementation InternalLoader
+ (void)load { registerClass(); }
@end

// MARK: -

void registerClass() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL _userDefaults_sel   = sel_registerName(kUserDefaultsGet_name);
        SEL _repository_sel     = sel_registerName(kRepositoryGet_name);
        SEL _rssLinks_sel       = sel_registerName(kRSSLinksGet_name);
        SEL _saveState_sel      = @selector(saveState:);
        SEL _selectedLink_sel   = @selector(selectedLink);
        SEL _selectLink_sel     = @selector(selectLink:);
        SEL _updateLink_sel     = @selector(updateLink:);
        SEL _deleteLink_sel     = @selector(deleteLink:);
        SEL _insertLink_sel     = @selector(insertLink:relativeToURL:);
        SEL _links_sel          = @selector(links);
        
        UVSourceManager = objc_allocateClassPair([NSObject class], kClassName, 0);
        class_addProtocol(UVSourceManager, @protocol(UVSourceManagerType));
        
        objc_property_attribute_t id_nonatomic_retain_attributes[] = {
            { "T", @encode(id) },
            { "N", "" },
            { "&", "" },
        };
        
        class_addIvar(UVSourceManager, kRSSLinksIvar_name, sizeof(NSMutableArray<RSSLink *>*), _Alignof(NSMutableArray<RSSLink *> *), @encode(NSMutableArray<RSSLink *> *));
        class_addProperty(UVSourceManager, kRSSLinksGet_name, id_nonatomic_retain_attributes, sizeof(id_nonatomic_retain_attributes) / sizeof(objc_property_attribute_t));
        
        class_addIvar(UVSourceManager, kRepositoryIvar_name, sizeof(id<UVPListRepositoryType>), _Alignof(id<UVPListRepositoryType>), @encode(id<UVPListRepositoryType>));
        class_addProperty(UVSourceManager, kRepositoryGet_name, id_nonatomic_retain_attributes, sizeof(id_nonatomic_retain_attributes) / sizeof(objc_property_attribute_t));
        
        class_addIvar(UVSourceManager, kUserDefaultsIvar_name, sizeof(NSUserDefaults *), _Alignof(NSUserDefaults *), @encode(NSUserDefaults *));
        class_addProperty(UVSourceManager, kUserDefaultsGet_name, id_nonatomic_retain_attributes, sizeof(id_nonatomic_retain_attributes) / sizeof(objc_property_attribute_t));
        
        Ivar _rssLinks_ivar = class_getInstanceVariable(UVSourceManager, kRSSLinksIvar_name);
        Ivar _repository_ivar = class_getInstanceVariable(UVSourceManager, kRepositoryIvar_name);
        Ivar _userDefaults_ivar = class_getInstanceVariable(UVSourceManager, kUserDefaultsIvar_name);
        
        // MARK: -
        
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
        class_addMethod(UVSourceManager, _rssLinks_sel, _rssLinks_imp, "@@:");
        
        // MARK: -
        
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
        class_addMethod(UVSourceManager, _repository_sel, _repository_imp, "@@:");
        
        // MARK: -
        
        IMP _userDefaults_imp = imp_implementationWithBlock(^id(id self){
            id _userDefaults_ref = object_getIvar(self, _userDefaults_ivar);
            if (!_userDefaults_ref) {
                id ud = NSUserDefaults.standardUserDefaults;
                object_setIvarWithStrongDefault(self, _userDefaults_ivar, ud);
                return object_getIvar(self, _userDefaults_ivar);
            }
            return _userDefaults_ref;
        });
        class_addMethod(UVSourceManager, _userDefaults_sel, _userDefaults_imp, "@@:");
        
        // MARK: -
        
        IMP _saveState_imp = imp_implementationWithBlock(^BOOL(id self, NSError **error){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            NSArray<NSDictionary *> *rawLinks = [_rssLinks_ref compactMap:^NSDictionary *(RSSLink *link) {
                return [link dictionaryFromObject];
            }];
            
            id<UVPListRepositoryType> _repository_ref = [self performSelector:_repository_sel];
            return [_repository_ref updateData:rawLinks error:error];
        });
        class_addMethod(UVSourceManager, _saveState_sel, _saveState_imp, "c@:@");
        
        // MARK: -
        
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
        class_addMethod(UVSourceManager, _selectedLink_sel, _selectedLink_imp, "@@:");
        
        // MARK: -
        
        IMP _selectLink_imp = imp_implementationWithBlock(^void(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref forEach:^(RSSLink *link) {
                link.selected = NO;
            }];
            link.selected = YES;
        });
        class_addMethod(UVSourceManager, _selectLink_sel, _selectLink_imp, "v@:@");
        
        // MARK: -
        
        IMP _updateLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref enumerateObjectsUsingBlock:^(RSSLink *obj, NSUInteger idx, BOOL *stop) {
                if ([obj isEqual:link]) _rssLinks_ref[idx] = link;
            }];
        });
        class_addMethod(UVSourceManager, _updateLink_sel, _updateLink_imp, "v@:@");
        
        // MARK: -
        
        IMP _deleteLink_imp = imp_implementationWithBlock(^(id self, RSSLink *link){
            NSMutableArray<RSSLink *> *_rssLinks_ref = [self performSelector:_rssLinks_sel];
            [_rssLinks_ref removeObject:link];
        });
        class_addMethod(UVSourceManager, _deleteLink_sel, _deleteLink_imp, "v@:@");
        
        // MARK: -
        
        IMP _insertLink_imp = imp_implementationWithBlock(^(id self , NSDictionary *rawLink, NSURL *url){
            NSMutableArray *_rssLinks_ref = object_getIvar(self, _rssLinks_ivar);
            
            RSSLink *link = ((RSSLink *(*)(id, SEL, NSDictionary *))objc_msgSend)(RSSLink.class, @selector(objectWithDictionary:), rawLink);
            ((void(*)(id, SEL, NSURL *))objc_msgSend)(link, @selector(configureURLRelativeToURL:), url);
            if (!((BOOL(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(containsObject:), link)){
                ((void(*)(id, SEL, RSSLink *))objc_msgSend)(_rssLinks_ref, @selector(addObject:), link);
            }
            
            object_setIvar(self, _rssLinks_ivar, _rssLinks_ref);
        });
        class_addMethod(UVSourceManager, _insertLink_sel, _insertLink_imp, "v@:@@");
        
        // MARK: -
        
        IMP _links_imp = imp_implementationWithBlock(^NSArray *(id self){
            return [self performSelector:_rssLinks_sel];
        });
        class_addMethod(UVSourceManager, _links_sel, _links_imp, "@@:");
        
        // MARK: -
        
        IMP _dealloc_imp = imp_implementationWithBlock(^(id self){
            [object_getIvar(self, _repository_ivar) release];
            [object_getIvar(self, _rssLinks_ivar) release];
            [object_getIvar(self, _userDefaults_ivar) release];
            
            struct objc_super super_entity = {
                self,
                class_getSuperclass(UVSourceManager)
            };
            ((void(*)(id, SEL))objc_msgSendSuper)((id)&super_entity, @selector(dealloc));
        });
        class_addMethod(UVSourceManager, @selector(dealloc), _dealloc_imp, "v@:");
        
        objc_registerClassPair(UVSourceManager);
    });
}
