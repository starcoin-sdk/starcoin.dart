
import 'package:starcoin_wallet/bcs/bcs.dart';

import 'serde/serde.dart';
import 'script/script.dart';
import 'starcoin/starcoin.dart';


class TransactionBuilder {

    /// Build a Diem {@link com.diem.types.Script} from a structured value {@link ScriptCall}.
    ///
    /// @param call {@link ScriptCall} value to encode.
    /// @return Encoded script.
    static Script encode_script(ScriptCall call) {
        ScriptEncodingHelper helper = TRANSACTION_SCRIPT_ENCODER_MAP[call.runtimeType.toString()];
        return helper(call);
    }

    /// Build a Diem {@link com.diem.types.TransactionPayload} from a structured value {@link ScriptFunctionCall}.
    ///
    /// @param call {@link ScriptFunctionCall} value to encode.
    /// @return Encoded TransactionPayload.
    static TransactionPayload encode_script_function(ScriptFunctionCall call) {
        ScriptFunctionEncodingHelper helper = SCRIPT_FUNCTION_ENCODER_MAP[call.runtimeType.toString()];
        return helper(call);
    }

    /// Try to recognize a Diem {@link com.diem.types.Script} and convert it into a structured value {@code ScriptCall}.
    ///
    /// @param script {@link com.diem.types.Script} values to decode.
    /// @return Decoded {@link ScriptCall} value.
    static ScriptCall decode_script(Script script)  {
        TransactionScriptDecodingHelper helper = TRANSACTION_SCRIPT_DECODER_MAP[script.code];
        if (helper == null) {
            throw new Exception("Unknown script bytecode");
        }
        return helper(script);
    }

    /**

     *
     * @param token_type {TypeTag} value
     * @param payee { AccountAddress} value
     * @param payee_auth_key { Bytes} value
     * @param amount { Int128} value
     * @return Encoded {@link com.diem.types.TransactionPayload} value.
     */
    static TransactionPayload encode_peer_to_peer_script_function(TypeTag tokenType, AccountAddress payee, Bytes payeeAuthKey, Int128 amount) {
        var tyArgs = [tokenType];
        BcsSerializer serializer = BcsSerializer();
        serializer.serialize_u128(amount);
        var amountBytes = serializer.get_bytes();
        BcsSerializer keySerializer = BcsSerializer();
        keySerializer.serialize_uint8list(payeeAuthKey.content);
        var keyBytes=keySerializer.get_bytes();
        var args = [payee.bcsSerialize(),keyBytes,amountBytes];
        var function = new Identifier("peer_to_peer");
        var module = new ModuleId(AccountAddress([ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 ]), new Identifier("TransferScripts"));

        return TransactionPayloadScriptFunctionItem(ScriptFunction(module,function,tyArgs,args));
    }


    static final Map<String, ScriptEncodingHelper> TRANSACTION_SCRIPT_ENCODER_MAP = initTransactionScriptEncoderMap();

    static Map<String, ScriptEncodingHelper> initTransactionScriptEncoderMap() {
        Map<String, ScriptEncodingHelper> map = new Map();
        return map;
    }


    static final Map<String, ScriptFunctionEncodingHelper> SCRIPT_FUNCTION_ENCODER_MAP = initScriptFunctionEncoderMap();

    static Map<String, ScriptFunctionEncodingHelper> initScriptFunctionEncoderMap() {
        Map<String, ScriptFunctionEncodingHelper> map = new Map();

        map[(ScriptFunctionCallPeerToPeerItem).toString()]= (call) {
            ScriptFunctionCallPeerToPeerItem obj = call as ScriptFunctionCallPeerToPeerItem;
            return TransactionBuilder.encode_peer_to_peer_script_function(obj.token_type, obj.payee, obj.payee_auth_key, obj.amount);
        };

        return map;
    }


    static final Map<Bytes, TransactionScriptDecodingHelper> TRANSACTION_SCRIPT_DECODER_MAP = initTransactionScriptDecoderMap();

    static Map<Bytes, TransactionScriptDecodingHelper> initTransactionScriptDecoderMap() {
        Map<Bytes, TransactionScriptDecodingHelper> map = new Map();
        return map;
    }


    static final Map<String, ScriptFunctionDecodingHelper> SCRIPT_FUNCTION_DECODER_MAP = initDecoderMap();

    static Map<String, ScriptFunctionDecodingHelper> initDecoderMap() {
        Map<String, ScriptFunctionDecodingHelper> map = new Map();
        return map;
    }

    static bool decode_bool_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentBoolItem)) {
            throw new Exception("Was expecting a Bool argument");
        }
        return (arg).value;
    }


    static int decode_u8_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentU8Item)) {
            throw new Exception("Was expecting a U8 argument");
        }
        return (arg).value;
    }


    static int decode_u64_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentU64Item)) {
            throw new Exception("Was expecting a U64 argument");
        }
        return (arg).value;
    }


    static Int128 decode_u128_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentU128Item)) {
            throw new Exception("Was expecting a U128 argument");
        }
        return (arg).value;
    }


    static AccountAddress decode_address_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentAddressItem)) {
            throw new Exception("Was expecting a Address argument");
        }
        return (arg).value;
    }


    static Bytes decode_u8vector_argument(TransactionArgument arg) {
        if (!(arg is TransactionArgumentU8VectorItem)) {
            throw new Exception("Was expecting a U8Vector argument");
        }
        return (arg).value;
    }


}


typedef ScriptFunctionEncodingHelper = TransactionPayload Function(
      ScriptFunctionCall call);
            
typedef ScriptFunctionDecodingHelper = ScriptFunctionCall Function(
      TransactionPayload call);

typedef TransactionScriptDecodingHelper = ScriptCall Function(
      Script script);

typedef ScriptEncodingHelper = Script Function(
      ScriptCall call);

