// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var React = require("react");
var Core = require("@material-ui/core");
var DockerListModuleCss = require("./DockerList.module.css");

var styles = DockerListModuleCss;

function getDialog(toggleContainerState, onClose, c) {
  if (!c) {
    return React.createElement(Core.Dialog, {
                aria_labelledby: "dockerlist-dialog-title",
                open: false
              });
  }
  var container = c._0;
  var state = container.State;
  var isRunning = state === "running";
  var status = container.Status;
  var name = container.Names.map(function (name) {
          return name.slice(1);
        }).join(" ");
  var questionPrefix = "Do you want to";
  return React.createElement(Core.Dialog, {
              aria_labelledby: "dockerlist-dialog-title",
              children: null,
              open: true
            }, React.createElement(Core.DialogTitle, {
                  children: name + " (" + state + ")",
                  id: "dockerlist-dialog-title"
                }), React.createElement(Core.DialogContent, {
                  children: null
                }, React.createElement(Core.Typography, {
                      children: status
                    }), React.createElement(Core.Typography, {
                      children: isRunning ? questionPrefix + " stop " + name + "?" : questionPrefix + " start " + name + "?"
                    })), React.createElement(Core.DialogActions, {
                  children: null
                }, React.createElement(Core.Button, {
                      onClick: (function (_ev) {
                          return Curry._1(onClose, undefined);
                        }),
                      children: "cancel",
                      color: "secondary"
                    }), React.createElement(Core.Button, {
                      onClick: (function (_ev) {
                          var __x = Curry._1(toggleContainerState, container);
                          __x.then(function (_containers) {
                                Curry._1(onClose, undefined);
                                return Promise.resolve(undefined);
                              });
                          
                        }),
                      children: "OK",
                      color: "primary"
                    })));
}

function Dialog(Props) {
  return getDialog(Props.toggleContainerState, Props.close, Props.container);
}

var make = Dialog;

exports.styles = styles;
exports.getDialog = getDialog;
exports.make = make;
/* styles Not a pure module */