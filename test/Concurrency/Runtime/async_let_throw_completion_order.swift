// rdar://81481317
// RUN: %target-run-simple-swift(-Xfrontend -disable-availability-checking -parse-as-library) | %FileCheck %s
// REQUIRES: executable_test
// REQUIRES: concurrency

// rdar://82123254
// REQUIRES: concurrency_runtime
// UNSUPPORTED: back_deployment_runtime

// rdar://124277662
// XFAIL: freestanding

struct Bad: Error {}

class Foo { init() async throws {}; deinit { print("Foo down") } }
class Bar { init() async throws { throw Bad() }; deinit { print("Bar down") } }
class Baz { init() async throws {}; deinit { print("Baz down") } }

func zim(y: Bar, x: Foo, z: Baz) { print("hooray") }

@main struct Butt {

  static func main() async {
    do {
      async let x = Foo()
      async let y = Bar()
      async let z = Baz()

      return try await zim(y: y, x: x, z: z)
    } catch {
      // CHECK: oopsie whoopsie
      print("oopsie whoopsie")
    }
  }
}
