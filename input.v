module mui

const (
	is_japanese = is_system_language_japanese_checker()
)

fn is_system_language_japanese_checker () bool {
	return $if support_japanese_input? {
		true
	} $else {
		false
	}
}

pub fn is_system_language_japanese() bool {
	return is_japanese
}