// RUN: %clang_cc1 -triple thumbv7-windows-msvc -fobjc-runtime=ios-6.0 -fobjc-arc -o - -emit-llvm %s | FileCheck %s

@protocol P;
@protocol Q;

@class I;

void f(id<P>, id, id<P>, id) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_object@U?$Protocol@UP@@@__ObjC@@@@PAUobjc_object@@01@Z"

void f(id, id<P>, id<P>, id) {}
// CHECK-LABEL: "\01?f@@YAXPAUobjc_object@@PAU?$objc_object@U?$Protocol@UP@@@__ObjC@@@@10@Z"

void f(id<P>, id<P>) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_object@U?$Protocol@UP@@@__ObjC@@@@0@Z"

void f(id<P>) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_object@U?$Protocol@UP@@@__ObjC@@@@@Z"

void f(id<P, Q>) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_object@U?$Protocol@UP@@@__ObjC@@U?$Protocol@UQ@@@2@@@@Z"

void f(Class<P>) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_class@U?$Protocol@UP@@@__ObjC@@@@@Z"

void f(Class<P, Q>) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$objc_class@U?$Protocol@UP@@@__ObjC@@U?$Protocol@UQ@@@2@@@@Z"

void f(I<P> *) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$I@U?$Protocol@UP@@@__ObjC@@@@@Z"

void f(I<P, Q> *) {}
// CHECK-LABEL: "\01?f@@YAXPAU?$I@U?$Protocol@UP@@@__ObjC@@U?$Protocol@UQ@@@2@@@@Z"

template <typename>
struct S {};

void f(S<__unsafe_unretained id>) {}
// CHECK-LABEL: "\01?f@@YAXU?$S@PAUobjc_object@@@@@Z"

void f(S<__autoreleasing id>) {}
// CHECK-LABEL: "\01?f@@YAXU?$S@U?$Autoreleasing@PAUobjc_object@@@__ObjC@@@@@Z"

void f(S<__strong id>) {}
// CHECK-LABEL: "\01?f@@YAXU?$S@U?$Strong@PAUobjc_object@@@__ObjC@@@@@Z"

void f(S<__weak id>) {}
// CHECK-LABEL: "\01?f@@YAXU?$S@U?$Weak@PAUobjc_object@@@__ObjC@@@@@Z"

void w(__weak id) {}
// CHECK-LABEL: "\01?w@@YAXPAUobjc_object@@@Z"

void s(__strong id) {}
// CHECK-LABEL: "\01?s@@YAXPAUobjc_object@@@Z"

void a(__autoreleasing id) {}
// CHECK-LABEL: "\01?a@@YAXPAUobjc_object@@@Z"

void u(__unsafe_unretained id) {}
// CHECK-LABEL: "\01?u@@YAXPAUobjc_object@@@Z"

S<__autoreleasing id> g() { return S<__autoreleasing id>(); }
// CHECK-LABEL: "\01?g@@YA?AU?$S@U?$Autoreleasing@PAUobjc_object@@@__ObjC@@@@XZ"

__autoreleasing id h() { return nullptr; }
// CHECK-LABEL: "\01?h@@YAPAUobjc_object@@XZ"
