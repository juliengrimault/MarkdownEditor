#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

SpecBegin(Dummy)

describe(@"Thing", ^{
    it(@"should do stuff",^{
        expect(1).to.equal(0);
    });
    
    pending(@"dummy pending");
});

SpecEnd
