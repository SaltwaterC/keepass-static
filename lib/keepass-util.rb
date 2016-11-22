def ruby_version
  arr = RUBY_VERSION.split '.'

  {
    major: arr[0].to_i,
    minor: arr[1].to_i,
    tiny: arr[2].to_i
  }
end

def ruby_platform
  arr = RUBY_PLATFORM.split '-'

  platform = {
    arch: arr[0],
    os: arr[1]
  }

  platform[:abi] = arr[2] if arr[2]

  platform
end
