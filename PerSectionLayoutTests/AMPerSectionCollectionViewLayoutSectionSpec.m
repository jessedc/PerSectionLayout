//
//  Copyright 2014 Dblechoc. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "AMPerSectionCollectionViewLayoutSection.h"
#import "AMFakeCollectionViewDelegateDataSource.h"
#import "AMPerSectionCollectionViewLayoutInfo.h"
#import "AMPerSectionCollectionViewLayoutRow.h"

@interface AMPerSectionCollectionViewLayoutSection (KIWIPrivateAccess)
- (void)computeLayout:(__unused AMPerSectionCollectionViewLayoutInfo *)layoutInfo;
@end

SPEC_BEGIN(AMPerSectionCollectionViewLayoutSectionSpec)

describe(@"AMPerSectionCollectionViewLayoutSection", ^{
    
    __block AMPerSectionCollectionViewLayoutSection *section;
    
    context(@"Adding a new item", ^{
        __block id addedItem ;
        
        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            addedItem = [section addItem];
        });
        
        it(@"should return the added item", ^{
            [[addedItem should] beNonNil];
        });
        
        it(@"should add a new layout item to the array of section items", ^{
            [[section.layoutSectionItems should] contain:addedItem];
        });
        
        it(@"should be a kind of AMPerSectionCollectionViewLayoutItem", ^{
            [[addedItem should] beKindOfClass:[AMPerSectionCollectionViewLayoutItem class]];
        });
    });
    
    context(@"adding a new row", ^{
        __block id addedItem;
        
        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            addedItem = [section addRow];
        });
        
        it(@"addRow should return the added row", ^{
            [[addedItem should] beNonNil];
        });
        
        it(@"should add a new layout row to the array of section rows", ^{
            [[section.layoutSectionRows should] contain:addedItem];
        });
        
        it(@"should add a kind of AMPerSectionCollectionViewLayoutRow", ^{
            [[addedItem should] beKindOfClass:[AMPerSectionCollectionViewLayoutRow class]];
        });
    });
    
    context(@"invalidation", ^{
        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            [section addRow];
            [section invalidate];
        });
        
        it(@"should clear any computed rows", ^{
            [[[section layoutSectionRows] should] beEmpty];
        });
    });
    
    context(@"a standard layout", ^{
        beforeEach(^{
            section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            section.width = 300;
            
            //add a few items
            AMPerSectionCollectionViewLayoutItem *item1 = [section addItem];;
            item1.frame = CGRectMake(0, 0, 100, 100);
            
            AMPerSectionCollectionViewLayoutItem *item2 = [section addItem];;
            item2.frame = CGRectMake(0, 0, 100, 150);
            
            AMPerSectionCollectionViewLayoutItem *item3 = [section addItem];;
            item3.frame = CGRectMake(0, 0, 100, 150);
            
            AMPerSectionCollectionViewLayoutItem *item4 = [section addItem];;
            item4.frame = CGRectMake(0, 0, 100, 100);
            
            [section computeLayout:nil];
        });
        
        it(@"should create two rows", ^{
            [[section.layoutSectionRows should] haveCountOf:2];
        });
        
        it(@"should have a body frame that accounts for the layout of the two rows", ^{
            [[theValue(section.bodyFrame) should] equal:theValue(CGRectMake(0, 0, 300, 250))];
        });
        
        it(@"should have a frame that accounts for the body frame an no headers", ^{
            [[theValue(section.frame) should] equal:theValue(CGRectMake(0, 0, 300, 250))];
        });
        
        it(@"should have no header or footer frame", ^{
            [[theValue(section.headerFrame) should] equal:theValue(CGRectZero)];
            [[theValue(section.footerFrame) should] equal:theValue(CGRectZero)];
        });
        
        it(@"should size the two rows and lay them out vertically", ^{
            NSArray *rows = section.layoutSectionRows;
            
            AMPerSectionCollectionViewLayoutRow *firstRow = rows[0];
            [[theValue([firstRow itemsCount]) should] equal:@3];
            [[theValue(firstRow.index) should] equal:theValue(0)];
            [[theValue(firstRow.frame) should] equal:theValue(CGRectMake(0, 0, 300, 150))];
            
            AMPerSectionCollectionViewLayoutRow *secondRow = rows[1];
            [[theValue([secondRow itemsCount]) should] equal:@1];
            [[theValue(secondRow.index) should] equal:theValue(1)];
            [[theValue(secondRow.frame) should] equal:theValue(CGRectMake(0, 150, 100, 100))];
        });
        
        context(@"with a footer frame", ^{
            beforeEach(^{
                section.footerFrame = CGRectMake(0, 0, 400, 50);
                [section invalidate];
                [section computeLayout:nil];
            });
            
            it(@"should place the footer frame at the bottom of the body frame with the width set to the overall width of the section", ^{
                [[theValue(section.footerFrame) should] equal:theValue(CGRectMake(0, 250, 300, 50))];
            });
            
            it(@"should size the frame to take into account the footer frame", ^{
                [[theValue(section.frame) should] equal:theValue(CGRectMake(0, 0, 300, 300))];
            });
        });
        
        context(@"with a header frame", ^{
            beforeEach(^{
                section.headerFrame = CGRectMake(100, 100, 400, 50);
                [section invalidate];
                [section computeLayout:nil];
            });
            
            it(@"should place the header at the top of the frame, keeping it's size bound to the section width",^{
                [[theValue(section.headerFrame) should] equal:theValue(CGRectMake(0, 0, 300, 50))];
            });
            
            it(@"should place the body underneath the header",^{
                [[theValue(section.bodyFrame) should] equal:theValue(CGRectMake(0, 50, 300, 250))];
            });
            
            it(@"it should size the frame to take into account the header frame",^{
                [[theValue(section.frame) should] equal:theValue(CGRectMake(0, 0, 300, 300))];
            });
        });
        
        context(@"with section margins", ^{
            beforeEach(^{
                section.sectionMargins = UIEdgeInsetsMake(5, 10, 5, 10);
                [section invalidate];
                [section computeLayout:nil];
            });
            
            it(@"should inset the body frame", ^{
                //third item is 150 high.
                [[theValue(section.bodyFrame) should] equal:theValue(CGRectMake(10, 5, 280, 300))];
            });
            
            it(@"should have a frame that accounts for the margins", ^{
                [[theValue(section.frame) should] equal:theValue(CGRectMake(0, 0, 300, 310))];
            });
            
            it(@"should cause the third item to move to the second row because of the constrained width",^{
                NSArray *rows = section.layoutSectionRows;
                AMPerSectionCollectionViewLayoutRow *firstRow = rows[0];
                [[theValue([firstRow itemsCount]) should] equal:theValue(2)];
                
                AMPerSectionCollectionViewLayoutRow *secondRow = rows[1];
                [[theValue([secondRow itemsCount]) should] equal:theValue(2)];
            });
            
            context(@"with a header frame", ^{
                beforeEach(^{
                    section.headerFrame = CGRectMake(100, 100, 400, 50);
                    [section invalidate];
                    [section computeLayout:nil];
                });
                
                it(@"should still be the full width of the section and be at the top ignoring the margins", ^{
                    [[theValue(section.headerFrame) should] equal:theValue(CGRectMake(0, 0, 300, 50))];
                });
            });
        });
        
        context(@"with a vertical interstice", ^{
            beforeEach(^{
                section.verticalInterstice = 10;
                [section invalidate];
                [section computeLayout:nil];
            });
            
            it(@"should place the second row the right number of points below the first line", ^{
                NSArray *rows = section.layoutSectionRows;
                
                AMPerSectionCollectionViewLayoutRow *firstRow = rows[0];
                [[theValue(firstRow.frame) should] equal:theValue(CGRectMake(0, 0, 300, 150))];
                
                AMPerSectionCollectionViewLayoutRow *secondRow = rows[1];
                [[theValue(secondRow.frame) should] equal:theValue(CGRectMake(0, 160, 100, 100))];
            });
            
            it(@"should have a body frame that accounts for the layout of the two rows", ^{
                [[theValue(section.bodyFrame) should] equal:theValue(CGRectMake(0, 0, 300, 270))];
            });
            
            it(@"should have a frame that accounts for the body frame an no headers", ^{
                [[theValue(section.frame) should] equal:theValue(CGRectMake(0, 0, 300, 270))];
            });
        });
        
        context(@"sticky", ^{
            beforeEach(^{
                section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
            });
            
            context(@"by default", ^{
                it(@"should not be sticky by default", ^{
                    [[theValue(section.sticky) should] beFalse];
                });
            });
            
            context(@"once set", ^{
                __block BOOL sticky = NO;
                
                beforeEach(^{
                    sticky = YES;
                    section.sticky = sticky;
                });
                
                it(@"should remember if is sticky or not", ^{
                    [[theValue(section.sticky) should] equal:theValue(sticky)];
                });
            });
        });
        
        context(@"stickyFrameForYOffset", ^{
            beforeEach(^{
                section = [[AMPerSectionCollectionViewLayoutSection alloc] init];
                section.frame = CGRectMake(0.f, 20.f, 200.f, 50.f);
            });
            
            context(@"section is sticky", ^{
                beforeEach(^{
                    section.sticky = YES;
                });
                
                it(@"should have per sticky frame the section frame", ^{
                    [[theValue([section stickyFrameForYOffset:400]) should] equal:theValue(CGRectMake(0.f, 420.f, 200.f, 50.f))];
                });
            });
            
            context(@"sectio isn't sticky", ^{
                beforeEach(^{
                    section.sticky = NO;
                });
                
                it(@"should have per sticky frame the section frame", ^{
                    [[theValue([section stickyFrameForYOffset:0]) should] equal:theValue(section.frame)];
                });
            });
        });
        
        //HorizontalInterstice is tested as part of the row
    });
});

SPEC_END
