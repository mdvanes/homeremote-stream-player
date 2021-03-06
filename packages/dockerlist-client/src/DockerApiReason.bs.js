// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Curry = require("rescript/lib/js/curry.js");
var Js_exn = require("rescript/lib/js/js_exn.js");

function getDockerList(url, onError) {
  return fetch(url + "/api/dockerlist").then(function (response) {
                  return response.json();
                }).then(function (jsonResponse) {
                if (jsonResponse.status === "received") {
                  return Promise.resolve(jsonResponse.containers);
                } else {
                  return Js_exn.raiseError("Invalid getDockerList response");
                }
              }).catch(function (_err) {
              Curry._1(onError, "error in getDockerList");
              return Promise.resolve([]);
            });
}

function startContainer(url, id, onError) {
  return fetch(url + ("/api/dockerlist/start/" + id)).then(function (response) {
                  return response.json();
                }).then(function (jsonResponse) {
                if (jsonResponse.status === "received") {
                  return Promise.resolve([]);
                } else {
                  return Js_exn.raiseError("Invalid startContainer response");
                }
              }).catch(function (_err) {
              Curry._1(onError, "error in startContainer");
              return Promise.resolve([]);
            });
}

function stopContainer(url, id, onError) {
  return fetch(url + ("/api/dockerlist/stop/" + id)).then(function (response) {
                  return response.json();
                }).then(function (jsonResponse) {
                if (jsonResponse.status === "received") {
                  return Promise.resolve([]);
                } else {
                  return Js_exn.raiseError("Invalid stopContainer response");
                }
              }).catch(function (_err) {
              Curry._1(onError, "error in stopContainer");
              return Promise.resolve([]);
            });
}

exports.getDockerList = getDockerList;
exports.startContainer = startContainer;
exports.stopContainer = stopContainer;
/* No side effect */
