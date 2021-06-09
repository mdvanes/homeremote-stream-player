// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Jest = require("@glennsl/bs-jest/src/jest.bs.js");
var DockerUtil$MdworldHomeremoteDockerlist = require("../src/DockerUtil.bs.js");

Jest.describe("DockerUtil", (function (param) {
        Jest.test("toClassName skips disabled classes", (function (param) {
                var __x = Jest.Expect.expect(DockerUtil$MdworldHomeremoteDockerlist.toClassName([
                          {
                            TAG: /* Name */0,
                            _0: "show-always"
                          },
                          {
                            TAG: /* NameOn */1,
                            _0: "show-skip",
                            _1: false
                          },
                          {
                            TAG: /* NameOn */1,
                            _0: "show-on",
                            _1: true
                          }
                        ]));
                return Jest.Expect.toBe("show-always show-on", __x);
              }));
        return Jest.test("not_ toBe", (function (param) {
                      return Jest.Expect.toBe(4, Jest.Expect.not_(Jest.Expect.expect(3)));
                    }));
      }));

/*  Not a pure module */
