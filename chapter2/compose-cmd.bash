#!/usr/bin/env bash
carton install && \
carton exec -- mojo generate lite-app bulletin.pl && \
carton exec -- morbo bulletin.pl
