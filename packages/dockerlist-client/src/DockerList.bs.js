// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as DockerListModuleCss from "./DockerList.module.css";
import * as DockerApi$MdworldHomeremoteDockerlist from "./DockerApi.bs.js";
import * as ReasonApi$MdworldHomeremoteDockerlist from "./ReasonApi.bs.js";

var styles = DockerListModuleCss;

function DockerList$DockerListMod(Props) {
  var count = Props.count;
  var times = count !== 1 ? (
      count !== 2 ? String(count) + " times" : "twice"
    ) : "once";
  var msg = "Click me " + times;
  var match = React.useState(function () {
        return [];
      });
  var setImgs = match[1];
  var match$1 = React.useState(function () {
        return [];
      });
  var setContainers = match$1[1];
  var dialogEl = React.useRef(null);
  React.useEffect((function () {
          DockerApi$MdworldHomeremoteDockerlist.Api.getDogsAndShow(function (_param) {
                return Curry._1(setImgs, (function (_prev) {
                              return _param;
                            }));
              });
          ReasonApi$MdworldHomeremoteDockerlist.getDockerList(undefined).then(function (containerList) {
                Curry._1(setContainers, (function (_prev) {
                        return containerList;
                      }));
                console.log("SpecialApiTestFunc: ", containerList);
                return Promise.resolve(containerList);
              });
          
        }), []);
  var handleClick = function (_event) {
    return DockerApi$MdworldHomeremoteDockerlist.Api.getDogsAndShow(function (_param) {
                return Curry._1(setImgs, (function (_prev) {
                              return _param;
                            }));
              });
  };
  var handleClickFetch = function (_event) {
    console.log("handleClickFetch");
    DockerApi$MdworldHomeremoteDockerlist.Api.getDogsFetch(undefined);
    ReasonApi$MdworldHomeremoteDockerlist.fetchDogs(undefined).then(function (imgList) {
          Curry._1(setImgs, (function (_prev) {
                  return imgList;
                }));
          console.log("SpecialApiTestFunc: ", imgList);
          return Promise.resolve(imgList);
        });
    ReasonApi$MdworldHomeremoteDockerlist.getDockerList(undefined).then(function (containerList) {
          Curry._1(setContainers, (function (_prev) {
                  return containerList;
                }));
          console.log("SpecialApiTestFunc: ", containerList);
          return Promise.resolve(containerList);
        });
    
  };
  var closeDialog = function (_event) {
    return Belt_Option.forEach(Caml_option.nullable_to_opt(dialogEl.current), (function (input) {
                  input.close();
                  
                }));
  };
  var imgElems = match[0].map(function (url) {
        return React.createElement("img", {
                    className: styles.image,
                    src: url
                  });
      });
  var dockerContainersElems = match$1[0].map(function (dockerContainer) {
        var className = styles.button + " " + (
          dockerContainer.State !== "running" ? styles.off : ""
        );
        return React.createElement("button", {
                    className: className
                  }, React.createElement("p", undefined, dockerContainer.Names), React.createElement("p", undefined, dockerContainer.Status));
      });
  return React.createElement("div", {
              className: styles.root
            }, React.createElement("h1", undefined, "Docker List"), React.createElement("h1", undefined, "Docker List"), React.createElement("div", {
                  className: styles["button-container"]
                }, React.createElement("button", {
                      className: styles.button + " " + styles.off,
                      onClick: handleClick
                    }, msg), React.createElement("button", {
                      className: styles.button + " " + styles.off,
                      onClick: handleClickFetch
                    }, "with Fetch Api"), React.createElement("button", {
                      className: styles.button + " " + styles.off,
                      onClick: handleClickFetch
                    }, React.createElement("h1", undefined, "Name"), React.createElement("p", undefined, "Off")), React.createElement("button", {
                      className: styles.button,
                      onClick: handleClickFetch
                    }, React.createElement("h1", undefined, "Bladiebla"), React.createElement("p", undefined, "Up 2 days")), React.createElement("button", {
                      className: styles.button + " " + styles.error,
                      onClick: handleClickFetch
                    }, React.createElement("h1", undefined, "Errrr"), React.createElement("p", undefined, "Borked"))), dockerContainersElems, React.createElement("div", undefined, imgElems), React.createElement("dialog", {
                  ref: dialogEl
                }, "are you sure you want to start container SOMEConTAINEr", React.createElement("button", {
                      onClick: closeDialog
                    }, "close")));
}

var DockerListMod = {
  make: DockerList$DockerListMod
};

export {
  styles ,
  DockerListMod ,
  
}
/* styles Not a pure module */
