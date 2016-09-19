def ruby_version
  arr = RUBY_VERSION.split '.'

  {
    major: arr[0].to_i,
    minor: arr[1].to_i,
    tiny: arr[2].to_i
  }
end
