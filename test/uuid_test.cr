require "minitest/autorun"
require "../src/uuid"

describe UUID do
  describe "default initialize" do
    it "initialize with no options" do
      subject = UUID.new
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with variant" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8), variant: UUID::Variant::NCS)
      assert_equal UUID::Variant::NCS, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with slice and version" do
      subject = UUID.new(version: UUID::Version::V3)
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V3, subject.version
    end
  end

  describe "initialize with slice" do
    it "initialize with slice only" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8))
      assert_equal "00000000-0000-4000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with slice and variant" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8), variant: UUID::Variant::NCS)
      assert_equal "00000000-0000-4000-0000-000000000000", subject.to_s
      assert_equal UUID::Variant::NCS, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with slice and version" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8), version: UUID::Version::V3)
      assert_equal "00000000-0000-3000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V3, subject.version
    end
  end

  describe "initialize with static array" do
    it "initialize with static array only" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8))
      assert_equal "00000000-0000-4000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with static array and variant" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8), variant: UUID::Variant::NCS)
      assert_equal "00000000-0000-4000-0000-000000000000", subject.to_s
      assert_equal UUID::Variant::NCS, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with static array and version" do
      subject = UUID.new(StaticArray(UInt8, 16).new(0_u8), version: UUID::Version::V3)
      assert_equal "00000000-0000-3000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V3, subject.version
    end
  end

  describe "initialize with String" do
    it "initialize with static array only" do
      subject = UUID.new("00000000-0000-0000-0000-000000000000")
      assert_equal "00000000-0000-4000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with static array and variant" do
      subject = UUID.new("00000000-0000-0000-0000-000000000000", variant: UUID::Variant::NCS)
      assert_equal "00000000-0000-4000-0000-000000000000", subject.to_s
      assert_equal UUID::Variant::NCS, subject.variant
      assert_equal UUID::Version::V4, subject.version
    end

    it "initialize with static array and version" do
      subject = UUID.new("00000000-0000-0000-0000-000000000000", version: UUID::Version::V3)
      assert_equal "00000000-0000-3000-8000-000000000000", subject.to_s
      assert_equal UUID::Variant::RFC4122, subject.variant
      assert_equal UUID::Version::V3, subject.version
    end

    it "can be built from strings" do
      assert_equal "c20335c3-7f46-4126-aae9-f665434ad12b", UUID.new("c20335c3-7f46-4126-aae9-f665434ad12b").to_s
      assert_equal "c20335c3-7f46-4126-aae9-f665434ad12b", UUID.new("c20335c37f464126aae9f665434ad12b").to_s
      assert_equal "c20335c3-7f46-4126-aae9-f665434ad12b", UUID.new("C20335C3-7F46-4126-AAE9-F665434AD12B").to_s
      assert_equal "c20335c3-7f46-4126-aae9-f665434ad12b", UUID.new("C20335C37F464126AAE9F665434AD12B").to_s
    end
  end

  it "initializes zeroed UUID" do
    assert_equal UUID.new(StaticArray(UInt8, 16).new(0_u8), UUID::Variant::NCS, UUID::Version::V4), UUID.empty
    assert_equal "00000000-0000-4000-0000-000000000000", UUID.empty.to_s
    assert_equal UUID::Variant::NCS, UUID.empty.variant
    assert_equal UUID::Version::V4, UUID.empty.version
  end

  describe "supports different string formats" do
    it "normal output" do
      assert_equal "ee843b26-56d8-472b-b343-0b94ed9077ff", UUID.new("ee843b2656d8472bb3430b94ed9077ff").to_s
    end

    it "hexstring" do
      assert_equal "3e806983eca44fc5b581f30fb03ec9e5", UUID.new("3e806983-eca4-4fc5-b581-f30fb03ec9e5").hexstring
    end

    it "urn" do
      assert_equal "urn:uuid:1ed1ee2f-ef9a-4f9c-9615-ab14d8ef2892", UUID.new("1ed1ee2f-ef9a-4f9c-9615-ab14d8ef2892").urn
    end

    it "compares to strings" do
      uuid = UUID.new "c3b46146eb794e18877b4d46a10d1517"
      assert uuid == "c3b46146eb794e18877b4d46a10d1517"
      assert uuid == "c3b46146-eb79-4e18-877b-4d46a10d1517"
      assert uuid == "C3B46146-EB79-4E18-877B-4D46A10D1517"
      assert uuid == "urn:uuid:C3B46146-EB79-4E18-877B-4D46A10D1517"
      assert uuid == "urn:uuid:c3b46146-eb79-4e18-877b-4d46a10d1517"
      assert uuid == "C3B46146-EB79-4E18-877B-4D46A10D1517"
    end
  end

  it "fails on invalid arguments when creating" do
    assert_raises(ArgumentError) { UUID.new "" }
    assert_raises(ArgumentError) { UUID.new "25d6f843?cf8e-44fb-9f84-6062419c4330" }
    assert_raises(ArgumentError) { UUID.new "67dc9e24-0865 474b-9fe7-61445bfea3b5" }
    assert_raises(ArgumentError) { UUID.new "5942cde5-10d1-416b+85c4-9fc473fa1037" }
    assert_raises(ArgumentError) { UUID.new "0f02a229-4898-4029-926f=94be5628a7fd" }
    assert_raises(ArgumentError) { UUID.new "cda08c86-6413-474f-8822-a6646e0fb19G" }
    assert_raises(ArgumentError) { UUID.new "2b1bfW06368947e59ac07c3ffdaf514c" }
  end

  it "fails when comparing to invalid strings" do
    assert_raises(ArgumentError) { UUID.new == "" }
    assert_raises(ArgumentError) { UUID.new == "d1fb9189-7013-4915-a8b1-07cfc83bca3U" }
    assert_raises(ArgumentError) { UUID.new == "2ab8ffc8f58749e197eda3e3d14e0 6c" }
    assert_raises(ArgumentError) { UUID.new == "2ab8ffc8f58749e197eda3e3d14e 06c" }
    assert_raises(ArgumentError) { UUID.new == "2ab8ffc8f58749e197eda3e3d14e-76c" }
  end

  it "should handle variant" do
    uuid = UUID.new
    assert_raises(ArgumentError) { uuid.variant = UUID::Variant::Unknown }
    {% for variant in %w(NCS RFC4122 Microsoft Future) %}
      uuid.variant = UUID::Variant::{{ variant.id }}
      assert_equal UUID::Variant::{{ variant.id }}, uuid.variant
    {% end %}
  end

  it "should handle version" do
    uuid = UUID.new
    assert_raises(ArgumentError) { uuid.version = UUID::Version::Unknown }
    {% for version in %w(1 2 3 4 5) %}
      uuid.version = UUID::Version::V{{ version.id }}
      assert_equal UUID::Version::V{{ version.id }}, uuid.version
    {% end %}
  end
end
