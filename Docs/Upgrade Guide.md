# Upgrade Guide

This guide describes the steps required to upgrade from different versions of the library.

## 3.0.x -> 3.1

The signature to the JRCapture initialization method added a new parameter to its selector, `customIdentityProviders:`,
which describes custom identity providers to configure the library with. See `Engage Custom Provider Guide.md` for more
details.

## 3.1.x -> 3.2

The signature to the JRCapture initialization method added several new parameters to its selector.  See the selector
in `JRCapture.h` which begins "setEngageAppId:" for the current list of parameters.

## Generalized Process

A less desirable but more reliable and more general upgrade strategy:

1. Remove existing Janrain project groups
2. Remove generated Capture user model project groups
3. Follow the process described JUMP Integration Guide
