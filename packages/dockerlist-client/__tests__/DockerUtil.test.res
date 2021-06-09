open Jest

let () = describe("DockerUtil", () => {
  open Expect

  test("toClassName skips disabled classes", () =>
    expect(
      DockerUtil.toClassName([
        Name("show-always"),
        NameOn("show-skip", false),
        NameOn("show-on", true),
      ]),
    ) -> toBe("show-always show-on", _)
  )

  test("not_ toBe", () => expect(1 + 2) |> not_ |> toBe(4))
})
