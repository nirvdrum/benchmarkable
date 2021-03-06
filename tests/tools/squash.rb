#!/usr/bin/env ruby
# encoding: UTF-8

# Copyright (c) 2016 Oracle and/or its affiliates. All rights reserved. This
# code is released under a tri EPL/GPL/LGPL license. You can use it,
# redistribute it and/or modify it under the terms of the:
#
# Eclipse Public License version 1.0
# GNU General Public License version 2
# GNU Lesser General Public License version 2.1

state = :normal
last_xxx = false

ARGF.set_encoding(Encoding::UTF_8) if defined?(Encoding)

ARGF.each_line do |line|
  
  # Squash multiple whitespace into a single space
  line.gsub! /\s+/, ' '
  
  # Squash any numbers into XXX
  line.gsub! /\b\d+(\.\d+)?[kMBTQs]?\b/, 'XXX'
  
  # Squash ±
  line.gsub! /±\s*/, ''
  
  # Squash bips' XXX in XXX to just XXX
  line.gsub! /XXX in XXX/, 'XXX'
  
  # Squash whitespace out of ( XXX )
  line.gsub! /\(\s*XXX\s*\)/, '(XXX)'
  
  # Turn any lines following Comparison: into XXX as the order can change
  if state == :normal
    if line.strip == 'Comparison:'
      state = :comparison
    end
  elsif state == :comparison
    if line.strip.empty?
      state = :normal
    else
      line = ' XXX'
    end
  end
  
  if line.strip == 'XXX'
    if last_xxx
      line = nil
    else
      last_xxx = true
    end
  else
    last_xxx = false
  end
  
  puts line unless line == nil
end
